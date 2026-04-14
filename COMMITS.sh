

# ── Commit 1 — Estructura inicial ────────────────────────────
git init
git branch -M main
git add README.md .gitignore
git commit -m "Inicializar repositorio laboratorio Post2 U4"

# ── Commit 2 — Macros y programa base ────────────────────────
git add macros.asm programa2.asm
git commit -m "Agregar biblioteca de macros y programa base con repetir_str"

# ── Commit 3 — Versión funcional con capturas ────────────────
git add capturas/
git commit -m "Implementar sumar_serie y comparar_e_imprimir con CMP/JG/JE"

# ── Subir a GitHub ───────────────────────────────────────────
git remote add origin https://github.com/TU_USUARIO/Torres-post2-u4.git
git push -u origin main

# ── Verificar historial ──────────────────────────────────────
git log --oneline
