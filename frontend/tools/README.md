# Vendored Flutter SDK (optional)

This project supports an optional, repo-local Flutter SDK to make it easier for
contributors who cannot or do not want to reference an SDK on an external disk.

How to use

- Place a Flutter SDK copy under `frontend/tools/flutter` (this is *not* recommended for large teams
  since the SDK is large). A better option is to create a small script or symlink on your machine.
- If `frontend/tools/flutter` exists, the iOS build helper `ios/Flutter/flutter_export_environment.sh`
  will prefer it automatically.

Recommended alternatives

- Create a symlink to an installed SDK instead of copying it into the repo:

```bash
cd frontend/tools
ln -s /path/to/flutter flutter
```

- Or install Flutter per the official docs and add it to your PATH. The repo will fall back to the
  system-installed Flutter if no vendored SDK is present.

Notes

- Do NOT commit a full Flutter SDK to the repository unless you understand the storage and
  bandwidth implications. If you must, add the SDK path to `.git/info/exclude` or the project's
  root `.gitignore` temporarily.
