// API REST para SmartWallet - Integración con Interledger Open Payments
import express from "express";
import cors from "cors";
import {
  createAuthenticatedClient,
  isFinalizedGrant,
} from "@interledger/open-payments";
import fs from "fs";

const app = express();
const PORT = process.env.PORT || 3001;

// Middleware
app.use(cors());
app.use(express.json());

// Configuración del cliente de Open Payments
let client;

async function initializeClient() {
  try {
    const privateKey = fs.readFileSync("private.key", "utf8");
    client = await createAuthenticatedClient({
      walletAddressUrl: "https://ilp.interledger-test.dev/ian",
      privateKey: privateKey,
      keyId: "e42434cd-91a9-453e-b6fc-bd68e81823c1",
    });
    console.log("✅ Cliente de Open Payments inicializado");
  } catch (error) {
    console.error("❌ Error al inicializar cliente:", error);
    throw error;
  }
}

// =======================
// ENDPOINTS
// =======================

// Health check
app.get("/api/health", (req, res) => {
  res.json({ status: "ok", message: "SmartWallet API is running" });
});

// Obtener información de una wallet address
app.get("/api/wallet/:walletUrl(*)", async (req, res) => {
  try {
    const walletUrl = req.params.walletUrl;
    const fullUrl = walletUrl.startsWith("http")
      ? walletUrl
      : `https://${walletUrl}`;

    const walletAddress = await client.walletAddress.get({
      url: fullUrl,
    });

    res.json({
      success: true,
      data: walletAddress,
    });
  } catch (error) {
    console.error("Error obteniendo wallet:", error);
    res.status(500).json({
      success: false,
      error: error.message,
    });
  }
});

// Crear un incoming payment (para recibir dinero)
app.post("/api/incoming-payment", async (req, res) => {
  try {
    const { receiverWalletUrl, amount, assetCode, assetScale } = req.body;

    // Validación
    if (!receiverWalletUrl || !amount) {
      return res.status(400).json({
        success: false,
        error: "receiverWalletUrl y amount son requeridos",
      });
    }

    // Obtener información del receptor
    const receivingWalletAddress = await client.walletAddress.get({
      url: receiverWalletUrl,
    });

    // Solicitar grant para incoming payment
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
      throw new Error("Se esperaba que la concesión esté finalizada");
    }

    // Crear incoming payment
    const incomingPayment = await client.incomingPayment.create(
      {
        url: receivingWalletAddress.resourceServer,
        accessToken: incomingPaymentGrant.access_token.value,
      },
      {
        walletAddress: receivingWalletAddress.id,
        incomingAmount: {
          assetCode: assetCode || receivingWalletAddress.assetCode,
          assetScale: assetScale || receivingWalletAddress.assetScale,
          value: amount.toString(),
        },
      }
    );

    res.json({
      success: true,
      data: {
        incomingPayment,
        walletAddress: receivingWalletAddress,
      },
    });
  } catch (error) {
    console.error("Error creando incoming payment:", error);
    res.status(500).json({
      success: false,
      error: error.message,
    });
  }
});

// Crear una cotización (quote)
app.post("/api/quote", async (req, res) => {
  try {
    const { senderWalletUrl, receiverPaymentUrl } = req.body;

    if (!senderWalletUrl || !receiverPaymentUrl) {
      return res.status(400).json({
        success: false,
        error: "senderWalletUrl y receiverPaymentUrl son requeridos",
      });
    }

    // Obtener wallet del remitente
    const sendingWalletAddress = await client.walletAddress.get({
      url: senderWalletUrl,
    });

    // Solicitar grant para quote
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
      throw new Error("Se esperaba que la concesión esté finalizada");
    }

    // Crear cotización
    const quote = await client.quote.create(
      {
        url: sendingWalletAddress.resourceServer,
        accessToken: quoteGrant.access_token.value,
      },
      {
        walletAddress: sendingWalletAddress.id,
        receiver: receiverPaymentUrl,
        method: "ilp",
      }
    );

    res.json({
      success: true,
      data: {
        quote,
        walletAddress: sendingWalletAddress,
      },
    });
  } catch (error) {
    console.error("Error creando quote:", error);
    res.status(500).json({
      success: false,
      error: error.message,
    });
  }
});

// Iniciar un outgoing payment (enviar dinero)
app.post("/api/outgoing-payment/initiate", async (req, res) => {
  try {
    const { senderWalletUrl, quoteId, debitAmount } = req.body;

    if (!senderWalletUrl || !quoteId || !debitAmount) {
      return res.status(400).json({
        success: false,
        error: "senderWalletUrl, quoteId y debitAmount son requeridos",
      });
    }

    const sendingWalletAddress = await client.walletAddress.get({
      url: senderWalletUrl,
    });

    // Solicitar grant para outgoing payment (requiere interacción)
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
                debitAmount: debitAmount,
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

    res.json({
      success: true,
      data: {
        grantId: outgoingPaymentGrant.continue.uri,
        interactUrl: outgoingPaymentGrant.interact.redirect,
        continueToken: outgoingPaymentGrant.continue.access_token.value,
      },
      message: "El usuario debe visitar interactUrl para autorizar el pago",
    });
  } catch (error) {
    console.error("Error iniciando outgoing payment:", error);
    res.status(500).json({
      success: false,
      error: error.message,
    });
  }
});

// Completar un outgoing payment después de autorización
app.post("/api/outgoing-payment/complete", async (req, res) => {
  try {
    const { senderWalletUrl, grantId, continueToken, quoteId } = req.body;

    if (!senderWalletUrl || !grantId || !continueToken || !quoteId) {
      return res.status(400).json({
        success: false,
        error: "Todos los campos son requeridos",
      });
    }

    // Continuar con el grant
    const finalizedOutgoingPaymentGrant = await client.grant.continue({
      url: grantId,
      accessToken: continueToken,
    });

    if (!isFinalizedGrant(finalizedOutgoingPaymentGrant)) {
      throw new Error("Se esperaba que la concesión esté finalizada");
    }

    const sendingWalletAddress = await client.walletAddress.get({
      url: senderWalletUrl,
    });

    // Crear el outgoing payment
    const outgoingPayment = await client.outgoingPayment.create(
      {
        url: sendingWalletAddress.resourceServer,
        accessToken: finalizedOutgoingPaymentGrant.access_token.value,
      },
      {
        walletAddress: sendingWalletAddress.id,
        quoteId: quoteId,
      }
    );

    res.json({
      success: true,
      data: {
        outgoingPayment,
      },
      message: "Pago enviado exitosamente",
    });
  } catch (error) {
    console.error("Error completando outgoing payment:", error);
    res.status(500).json({
      success: false,
      error: error.message,
    });
  }
});

// Flujo completo simplificado (para demo - sin autorización interactiva)
app.post("/api/transfer/simple", async (req, res) => {
  try {
    const { senderWalletUrl, receiverWalletUrl, amount, currency } = req.body;

    if (!senderWalletUrl || !receiverWalletUrl || !amount) {
      return res.status(400).json({
        success: false,
        error: "senderWalletUrl, receiverWalletUrl y amount son requeridos",
      });
    }

    console.log("📥 Request recibido:", {
      senderWalletUrl,
      receiverWalletUrl,
      amount,
      currency,
    });

    // Asegurarnos de que amount sea un string numérico válido
    const amountValue = amount.toString();

    // Validar que sea un número
    if (isNaN(Number(amountValue)) || Number(amountValue) <= 0) {
      return res.status(400).json({
        success: false,
        error: "El monto debe ser un número válido mayor a 0",
      });
    }

    // 1. Obtener wallets
    const sendingWalletAddress = await client.walletAddress.get({
      url: senderWalletUrl,
    });
    const receivingWalletAddress = await client.walletAddress.get({
      url: receiverWalletUrl,
    });

    console.log("✅ Wallets obtenidas");
    console.log("📤 Remitente:", sendingWalletAddress.id);
    console.log("📥 Receptor:", receivingWalletAddress.id);
    console.log(
      "💰 Monto:",
      amountValue,
      currency || receivingWalletAddress.assetCode
    );

    // 2. Crear incoming payment
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
      throw new Error(
        "Se esperaba que la concesión de incoming payment esté finalizada"
      );
    }

    console.log("🔍 Detalles del receivingWalletAddress:");
    console.log("   assetCode:", receivingWalletAddress.assetCode);
    console.log("   assetScale:", receivingWalletAddress.assetScale);
    console.log("🔍 Creando incoming payment con:");
    console.log("   assetCode:", currency || receivingWalletAddress.assetCode);
    console.log("   assetScale:", receivingWalletAddress.assetScale);
    console.log("   value:", amountValue);
    console.log("   type:", typeof amountValue);

    const incomingPayment = await client.incomingPayment.create(
      {
        url: receivingWalletAddress.resourceServer,
        accessToken: incomingPaymentGrant.access_token.value,
      },
      {
        walletAddress: receivingWalletAddress.id,
        incomingAmount: {
          assetCode: receivingWalletAddress.assetCode, // USAR SIEMPRE EL DEL WALLET, NO EL DEL FRONTEND
          assetScale: receivingWalletAddress.assetScale,
          value: amountValue, // Ya viene en la escala correcta desde el frontend
        },
      }
    );

    console.log("✅ Incoming payment creado:", incomingPayment.id);

    // 3. Crear quote
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
      throw new Error("Se esperaba que la concesión de quote esté finalizada");
    }

    const quote = await client.quote.create(
      {
        url: sendingWalletAddress.resourceServer,
        accessToken: quoteGrant.access_token.value,
      },
      {
        walletAddress: sendingWalletAddress.id,
        receiver: incomingPayment.id,
        method: "ilp",
      }
    );

    // 4. Preparar respuesta con URL de autorización
    // En modo demo, retornamos la información para que el frontend sepa que necesita autorización
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

    res.json({
      success: true,
      requiresAuthorization: true,
      data: {
        incomingPayment,
        quote,
        authorizationUrl: outgoingPaymentGrant.interact.redirect,
        grantId: outgoingPaymentGrant.continue.uri,
        continueToken: outgoingPaymentGrant.continue.access_token.value,
        senderWallet: sendingWalletAddress,
        receiverWallet: receivingWalletAddress,
      },
      message: "Transferencia preparada. Se requiere autorización del usuario.",
    });
  } catch (error) {
    console.error("Error en transferencia simple:", error);
    res.status(500).json({
      success: false,
      error: error.message,
    });
  }
});

// Iniciar servidor
async function startServer() {
  try {
    await initializeClient();
    app.listen(PORT, () => {
      console.log(`🚀 SmartWallet API corriendo en http://localhost:${PORT}`);
      console.log(`📝 Endpoints disponibles:`);
      console.log(`   GET  /api/health`);
      console.log(`   GET  /api/wallet/:walletUrl`);
      console.log(`   POST /api/incoming-payment`);
      console.log(`   POST /api/quote`);
      console.log(`   POST /api/outgoing-payment/initiate`);
      console.log(`   POST /api/outgoing-payment/complete`);
      console.log(`   POST /api/transfer/simple`);
    });
  } catch (error) {
    console.error("❌ Error al iniciar servidor:", error);
    process.exit(1);
  }
}

startServer();
