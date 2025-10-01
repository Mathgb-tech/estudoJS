# Script para inicializar repositório Git e enviar para GitHub
# Uso: abra PowerShell como usuário, navegue até esta pasta e execute:
#   .\push-to-github.ps1

# 1) Verifica se o Git está instalado
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host "Git não encontrado. Por favor instale o Git antes de continuar." -ForegroundColor Yellow
    Write-Host "Baixe em: https://git-scm.com/download/win" -ForegroundColor Cyan
    exit 1
}

# 2) Configura variável do repositório remoto (modifique se necessário)
$remoteUrl = 'https://github.com/Mathgb-tech/estudoJS.git'

# 3) Inicializa repositório se necessário
if (-not (Test-Path .git)) {
    git init
    Write-Host "Repositório Git inicializado." -ForegroundColor Green
} else {
    Write-Host ".git já existe. Pulando git init." -ForegroundColor Cyan
}

# 4) Configurar usuário (opcional, comente se já configurado globalmente)
# git config user.name "Seu Nome"
# git config user.email "seu-email@example.com"

# 5) Adiciona/atualiza remote origin
$existingRemote = git remote get-url origin 2>$null
if ($LASTEXITCODE -eq 0) {
    Write-Host "Remote origin já configurado: $existingRemote" -ForegroundColor Cyan
    if ($existingRemote -ne $remoteUrl) {
        Write-Host "Atualizando remote origin para $remoteUrl" -ForegroundColor Yellow
        git remote remove origin
        git remote add origin $remoteUrl
    }
} else {
    git remote add origin $remoteUrl
    Write-Host "Remote origin adicionado: $remoteUrl" -ForegroundColor Green
}

# 6) Adiciona todos os arquivos e faz commit
git add .
# Só comita se houver mudanças
if (git status --porcelain) {
    git commit -m "Enviar pasta de exercício"
    Write-Host "Arquivos commitados." -ForegroundColor Green
} else {
    Write-Host "Nenhuma mudança para commitar." -ForegroundColor Cyan
}

# 7) Garante branch main
git branch -M main

# 8) Faz push para o remoto (pode pedir suas credenciais ou PAT)
Write-Host "Fazendo push para origin main..." -ForegroundColor Cyan
$push = git push -u origin main
if ($LASTEXITCODE -ne 0) {
    Write-Host "Push falhou. Verifique mensagens acima. Possíveis causas: autenticação ou repositório remoto não vazio." -ForegroundColor Red
    Write-Host "Se o repositório remoto já tiver commits, você pode usar: git pull --rebase origin main" -ForegroundColor Yellow
    Write-Host "Ou force (cuidado): git push -u origin main --force" -ForegroundColor Yellow
    exit 1
}

Write-Host "Push concluído com sucesso." -ForegroundColor Green
Write-Host "Se foi solicitada autenticação, insira seu usuário e um Personal Access Token (PAT) do GitHub como senha." -ForegroundColor Cyan
