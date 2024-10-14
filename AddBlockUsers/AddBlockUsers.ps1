# Função para desativar contas de usuário se existirem
function Disable-UserIfExists {
    param (
        [string]$username
    )
    
    # Verifica se o usuário existe e tenta desativá-lo
    if (Get-LocalUser -Name $username -ErrorAction SilentlyContinue) {
        Disable-LocalUser -Name $username
        Write-Host "Usuário '$username' desativado."
    } else {
        Write-Host "Usuário '$username' não encontrado."
    }
}

# Função para verificar e adicionar usuário ao grupo se existir
function Add-UserToGroupIfExists {
    param (
        [string]$groupName,
        [string]$username
    )

    # Verifica se o grupo existe
    if (Get-LocalGroup -Name $groupName -ErrorAction SilentlyContinue) {
        Add-LocalGroupMember -Group $groupName -Member $username
        Write-Host "Usuário '$username' adicionado ao grupo '$groupName'."
    } else {
        Write-Host "Grupo '$groupName' não encontrado."
    }
}

# Desativar contas de usuário
Disable-UserIfExists -username "sistem"
Disable-UserIfExists -username "Administrator"
Disable-UserIfExists -username "Administrador"
Disable-UserIfExists -username "user"
Disable-UserIfExists -username "users"

# Adicionar um novo usuário local com senha
$senha = ConvertTo-SecureString "SUA-SENHA" -AsPlainText -Force

# Verificar se o usuário já existe
if (-not (Get-LocalUser -Name "NOVO-USUARIO" -ErrorAction SilentlyContinue)) {
    # Criar o usuário local sem o parâmetro UserPrincipalName
    New-LocalUser -Name "NOVO-USUARIO" -Password $senha -Description "Usuário local"
    Write-Host "Usuário 'NOVO-USUARIO' criado."
} else {
    Write-Host "Usuário 'NOVO-USUARIO' já existe."
}

# Adicionar o usuário ao grupo Administradores
Add-UserToGroupIfExists -groupName "Administradores" -username "NOVO-USUARIO"
Add-UserToGroupIfExists -groupName "Administrators" -username "NOVO-USUARIO"

# Configurar a conta para que a senha nunca expire
try {
    Set-LocalUser -Name "NOVO-USUARIO" -PasswordNeverExpires $true
    Write-Host "Configurações de usuário aplicadas para 'NOVO-USUARIO'."
} catch {
    Write-Host "Erro ao configurar 'NOVO-USUARIO': $_"
}
