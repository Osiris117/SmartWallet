// Tutorial del cliente de Open Payments
// Objetivo: Realizar un pago entre pares entre dos direcciones de billetera (usando cuentas en la cuenta de prueba)

// https://ilp.interledger-test.dev/ian -> Cliente
// https://ilp.interledger-test.dev/arely -> Remitente
// https://ilp.interledger-test.dev/humberto -> Receptor

// Configuración inicial
import {
  createAuthenticatedClient,
  isFinalizedGrant,
} from "@interledger/open-payments";
import fs from "fs";
import Readline from "readline/promises";

// a. Importar dependencias y configurar el cliente
(async () => {
  const privateKey = fs.readFileSync("private.key", "utf8");
  const client = await createAuthenticatedClient({
    walletAddressUrl: "https://ilp.interledger-test.dev/ian",
    privateKey: privateKey,
    keyId: "e42434cd-91a9-453e-b6fc-bd68e81823c1",
  });

  const sendingWalletAddress = await client.walletAddress.get({
    url: "https://ilp.interledger-test.dev/arely",
  });
  const receivingWalletAddress = await client.walletAddress.get({
    url: "https://ilp.interledger-test.dev/humberto",
  });

  console.log({ sendingWalletAddress, receivingWalletAddress });

  // 2. Obtener una concesión para un pago entrante
  const incomingPaymentGrant = await client.grant.request(
    {
      url: receivingWalletAddress.authServer,
    },
    {
      access_token: {
        access: [
          {
            type: "incoming-payment",
            actions: ["create"],
          },
        ],
      },
    }
  );
  if (!isFinalizedGrant(incomingPaymentGrant)) {
    throw new Error("Se espera finalice la concesión");
  }
  console.log(incomingPaymentGrant);

  // 3. Crear un pago entrante para el receptor
  const incomingPayment = await client.incomingPayment.create(
    {
      url: receivingWalletAddress.resourceServer,
      accessToken: incomingPaymentGrant.access_token.value,
    },
    {
      walletAddress: receivingWalletAddress.id,
      incomingAmount: {
        assetCode: receivingWalletAddress.assetCode,
        assetScale: receivingWalletAddress.assetScale,
        value: "1000",
      },
    }
  );
  console.log({ incomingPayment });

  // 4. Crear un concesión para una cotización
  const quoteGrant = await client.grant.request(
    {
      url: sendingWalletAddress.authServer,
    },
    {
      access_token: {
        access: [
          {
            type: "quote",
            actions: ["create"],
          },
        ],
      },
    }
  );
  if (!isFinalizedGrant(quoteGrant)) {
    throw new Error("Se espera finalice la concesión");
  }
  console.log(quoteGrant);

  // 5. Obtener una cotización para el remitente
  const quote = await client.quote.create(
    {
      url: receivingWalletAddress.resourceServer,
      accessToken: quoteGrant.access_token.value,
    },
    {
      walletAddress: sendingWalletAddress.id,
      receiver: incomingPayment.id,
      method: "ilp",
    }
  );
  console.log({ quote });

  //   6. Obtener una concesión para un pago saliente
  const outgoingPaymentGrant = await client.grant.request(
    {
      url: sendingWalletAddress.authServer,
    },
    {
      access_token: {
        access: [
          {
            type: "outgoing-payment",
            actions: ["create"],
            limits: {
              debitAmount: quote.debitAmount,
            },
            identifier: sendingWalletAddress.id,
          },
        ],
      },
      interact: {
        start: ["redirect"],
      },
    }
  );
  console.log({ outgoingPaymentGrant });

  // 7. Continuar con la concesión del pago saliente
  console.log("Visita esta URL para autorizar el pago:");
  console.log(outgoingPaymentGrant.interact.redirect);

  await Readline.createInterface({
    input: process.stdin,
    output: process.stdout,
  }).question("Presione Enter después de autorizar en el navegador...");

  // 8. Finalizar la concesión del pago saliente
  const finalizedOutgoingPaymentGrant = await client.grant.continue({
    url: outgoingPaymentGrant.continue.uri,
    accessToken: outgoingPaymentGrant.continue.access_token.value,
  });
  if (!isFinalizedGrant(finalizedOutgoingPaymentGrant)) {
    throw new Error("Se espera finalice la concesión");
  }

  const outgoingPayment = await client.outgoingPayment.create(
    {
      url: sendingWalletAddress.resourceServer,
      accessToken: finalizedOutgoingPaymentGrant.access_token.value,
    },
    {
      walletAddress: sendingWalletAddress.id,
      quoteId: quote.id,
    }
  );
  console.log({ outgoingPayment });
})();
