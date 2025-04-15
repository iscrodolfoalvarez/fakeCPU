# --- AUTO-ELEVACIÓN A ADMINISTRADOR SI NO LO ESTÁ ---
If (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)) {
    $script = $MyInvocation.MyCommand.Definition
    Start-Process powershell -ArgumentList "-ExecutionPolicy Bypass -File `"$script`"" -Verb RunAs
    exit
}

# --- INTERFAZ MODERNA Y PROFESIONAL ---
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$form = New-Object System.Windows.Forms.Form
$form.Text = "fakeCPU - Editor visual del procesador"
$form.Size = New-Object System.Drawing.Size(650, 550)
$form.StartPosition = "CenterScreen"
$form.BackColor = [System.Drawing.Color]::FromArgb(240, 244, 248)
$form.FormBorderStyle = 'FixedDialog'
$form.MaximizeBox = $false
$form.Font = New-Object System.Drawing.Font("Segoe UI", 10)

# Estilo de botones
function Estilo-Boton {
    param ($boton, $color)
    $boton.BackColor = $color
    $boton.ForeColor = "White"
    $boton.FlatStyle = 'Flat'
    $boton.FlatAppearance.BorderSize = 0
    $boton.Height = 45
    $boton.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
}

$regPath = "HKLM:\HARDWARE\DESCRIPTION\System\CentralProcessor\0"
$currentProcessorName = (Get-ItemProperty -Path $regPath -Name "ProcessorNameString").ProcessorNameString

# Panel encabezado
$lblTitulo = New-Object System.Windows.Forms.Label
$lblTitulo.Text = "fakeCPU - Cambiar nombre visual del procesador"
$lblTitulo.Font = New-Object System.Drawing.Font("Segoe UI", 14, [System.Drawing.FontStyle]::Bold)
$lblTitulo.ForeColor = [System.Drawing.Color]::FromArgb(50, 50, 70)
$lblTitulo.Location = New-Object System.Drawing.Point(20, 20)
$lblTitulo.Size = New-Object System.Drawing.Size(600, 30)

# Línea separadora
$line = New-Object System.Windows.Forms.Label
$line.BorderStyle = 'Fixed3D'
$line.Height = 2
$line.Width = 590
$line.Location = New-Object System.Drawing.Point(20, 55)

# Etiqueta actual
$lblActual = New-Object System.Windows.Forms.Label
$lblActual.Text = "Nombre actual del procesador:"
$lblActual.Location = New-Object System.Drawing.Point(20, 70)
$lblActual.Size = New-Object System.Drawing.Size(400, 20)

# Texto actual
$txtActual = New-Object System.Windows.Forms.TextBox
$txtActual.Text = $currentProcessorName
$txtActual.Location = New-Object System.Drawing.Point(20, 95)
$txtActual.Size = New-Object System.Drawing.Size(590, 25)
$txtActual.ReadOnly = $true
$txtActual.BackColor = "White"

# Etiqueta nuevo
$lblNuevo = New-Object System.Windows.Forms.Label
$lblNuevo.Text = "Nuevo nombre del procesador:"
$lblNuevo.Location = New-Object System.Drawing.Point(20, 140)
$lblNuevo.Size = New-Object System.Drawing.Size(400, 20)

# Texto nuevo
$txtNuevo = New-Object System.Windows.Forms.TextBox
$txtNuevo.Location = New-Object System.Drawing.Point(20, 165)
$txtNuevo.Size = New-Object System.Drawing.Size(590, 25)

# Botón: aplicar nombre falso
$btnCambiar = New-Object System.Windows.Forms.Button
$btnCambiar.Text = "Aplicar nuevo nombre"
$btnCambiar.Location = New-Object System.Drawing.Point(20, 220)
$btnCambiar.Width = 270
Estilo-Boton $btnCambiar ([System.Drawing.Color]::FromArgb(0, 123, 255))
$btnCambiar.Add_Click({
    $nuevoNombre = $txtNuevo.Text
    if (![string]::IsNullOrWhiteSpace($nuevoNombre)) {
        try {
            Set-ItemProperty -Path $regPath -Name "ProcessorNameString" -Value $nuevoNombre
            [System.Windows.Forms.MessageBox]::Show("Nombre del procesador actualizado visualmente.`nReinicia el equipo para aplicar los cambios.", "¡Éxito!")
        } catch {
            [System.Windows.Forms.MessageBox]::Show("Error al modificar el registro. Ejecutaste como administrador?", "Error")
        }
    } else {
        [System.Windows.Forms.MessageBox]::Show("Ingresa un nombre válido para continuar.", "Campo vacío")
    }
})

# Botón: restaurar original
$btnRestaurar = New-Object System.Windows.Forms.Button
$btnRestaurar.Text = "Restaurar nombre original"
$btnRestaurar.Location = New-Object System.Drawing.Point(340, 220)
$btnRestaurar.Width = 270
Estilo-Boton $btnRestaurar ([System.Drawing.Color]::FromArgb(40, 167, 69))
$btnRestaurar.Add_Click({
    try {
        Set-ItemProperty -Path $regPath -Name "ProcessorNameString" -Value $currentProcessorName
        [System.Windows.Forms.MessageBox]::Show("Nombre original restaurado.`nReinicia para aplicar los cambios.", "Restaurado")
    } catch {
        [System.Windows.Forms.MessageBox]::Show("No se pudo restaurar el nombre.", "Error")
    }
})

# Botón: reiniciar
$btnReiniciar = New-Object System.Windows.Forms.Button
$btnReiniciar.Text = "Reiniciar equipo"
$btnReiniciar.Location = New-Object System.Drawing.Point(160, 290)
$btnReiniciar.Width = 300
Estilo-Boton $btnReiniciar ([System.Drawing.Color]::FromArgb(220, 53, 69))
$btnReiniciar.Add_Click({
    $confirm = [System.Windows.Forms.MessageBox]::Show("¿Seguro que deseas reiniciar el equipo ahora?", "Confirmar reinicio", "YesNo")
    if ($confirm -eq "Yes") {
        Restart-Computer -Force
    }
})

# Créditos
$lblPie = New-Object System.Windows.Forms.Label
$lblPie.Text = "Desarrollado por iscrodolfoalvarez"
$lblPie.Location = New-Object System.Drawing.Point(20, 390)
$lblPie.Size = New-Object System.Drawing.Size(600, 20)
$lblPie.ForeColor = [System.Drawing.Color]::Gray
$lblPie.Font = New-Object System.Drawing.Font("Segoe UI", 8, [System.Drawing.FontStyle]::Italic)

# Info del desarrollador
$lblLinks = New-Object System.Windows.Forms.Label
$lblLinks.Text = "YouTube, GitHub y PayPal"
$lblLinks.Location = New-Object System.Drawing.Point(20, 420)
$lblLinks.Size = New-Object System.Drawing.Size(600, 20)
$lblLinks.ForeColor = [System.Drawing.Color]::FromArgb(60,60,60)
$lblLinks.Font = New-Object System.Drawing.Font("Segoe UI", 8, [System.Drawing.FontStyle]::Regular)

# Botón: YouTube
$btnYouTube = New-Object System.Windows.Forms.Button
$btnYouTube.Text = "Visitar Canal de YouTube"
$btnYouTube.Location = New-Object System.Drawing.Point(20, 450)
$btnYouTube.Width = 200
Estilo-Boton $btnYouTube ([System.Drawing.Color]::FromArgb(0, 102, 204))
$btnYouTube.Add_Click({
    [System.Diagnostics.Process]::Start("https://www.youtube.com/channel/UCE-1AF84hPdbUijsUG2ckLw")
})

# Botón: GitHub
$btnGitHub = New-Object System.Windows.Forms.Button
$btnGitHub.Text = "Visitar GitHub"
$btnGitHub.Location = New-Object System.Drawing.Point(230, 450)
$btnGitHub.Width = 200
Estilo-Boton $btnGitHub ([System.Drawing.Color]::FromArgb(28, 28, 28))
$btnGitHub.Add_Click({
    [System.Diagnostics.Process]::Start("https://github.com/iscrodolfoalvarez")
})

# Botón: PayPal
$btnPayPal = New-Object System.Windows.Forms.Button
$btnPayPal.Text = "Apoyame en PayPal"
$btnPayPal.Location = New-Object System.Drawing.Point(440, 450)
$btnPayPal.Width = 180
Estilo-Boton $btnPayPal ([System.Drawing.Color]::FromArgb(0, 204, 102))
$btnPayPal.Add_Click({
    [System.Diagnostics.Process]::Start("https://www.paypal.com/paypalme/rodolfoalvarez90")
})

# Agregar controles
$form.Controls.Add($lblTitulo)
$form.Controls.Add($line)
$form.Controls.Add($lblActual)
$form.Controls.Add($txtActual)
$form.Controls.Add($lblNuevo)
$form.Controls.Add($txtNuevo)
$form.Controls.Add($btnCambiar)
$form.Controls.Add($btnRestaurar)
$form.Controls.Add($btnReiniciar)
$form.Controls.Add($lblPie)
$form.Controls.Add($lblLinks)
$form.Controls.Add($btnYouTube)
$form.Controls.Add($btnGitHub)
$form.Controls.Add($btnPayPal)

# Mostrar interfaz
$form.ShowDialog()
