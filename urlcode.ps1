[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Web")

# config
$code = 'utf-8'
$font = New-Object System.Drawing.Font("メイリオ",9)

# configure Form
$Form = New-Object System.Windows.Forms.Form
$Form.Size = New-Object System.Drawing.Size(800,600)
$Form.Text = 'URL Encode/Decode tool'
$Form.Font = $font
# $Form.BackColor = "gray"

# configure Source TextBox
$srcLabel = New-Object System.Windows.Forms.Label
$srcLabel.Location = New-Object System.Drawing.Point(100,75)
$srcLabel.Text = '変換前'
$Form.Controls.Add($srcLabel)

$SrcTextBox = New-Object System.Windows.Forms.TextBox
$SrcTextBox.Location = New-Object System.Drawing.Point(100,100)
$SrcTextBox.Size = New-Object System.Drawing.Size(400,100)
$SrcTextBox.Multiline = $true
$Form.Controls.Add($SrcTextBox)

$SrcTextBox.Add_KeyDown({
    if($_.Control -and $_.KeyCode -eq 'A'){
        $this.SelectAll()
        $_.SuppressKeyPress = $true
    }
})

# configure Destination TextBox
$dstLabel = New-Object System.Windows.Forms.Label
$dstLabel.Location = New-Object System.Drawing.Point(100,225)
$dstLabel.Text = '変換後'
$Form.Controls.Add($dstLabel)

$DstTextBox = New-Object System.Windows.Forms.TextBox
$DstTextBox.Location = New-Object System.Drawing.Point(100,250)
$DstTextBox.Size = New-Object System.Drawing.Size(400,100)
$DstTextBox.Multiline = $true
$Form.Controls.Add($DstTextBox)

$DstTextBox.Add_KeyDown({
    if($_.Control -and $_.KeyCode -eq 'A'){
        $this.SelectAll()
        $_.SuppressKeyPress = $true
    }
})

# CheckBox for Whitespace Encode
$CheckWhitespace = New-Object System.Windows.Forms.CheckBox
$CheckWhitespace.Location = New-Object System.Drawing.Point(400,30)
$CheckWhitespace.Size = New-Object System.Drawing.Size(200,30)
$CheckWhitespace.Text = "半角スペース => '%20'"
$Form.Controls.Add($CheckWhitespace)

function encode(){
    $txt = [System.Web.HttpUtility]::UrlEncode($SrcTextBox.Text, [Text.Encoding]::GetEncoding($code))
    $txt = $txt.Replace('+','%20')
    $DstTextBox.Text = $txt
}

function decode(){
    $txt = [System.Web.HttpUtility]::UrlDecode($SrcTextBox.Text, [Text.Encoding]::GetEncoding($code))
    if($CheckWhitespace.Checked -eq $true)
    {
        $txt = $txt.Replace(' ', '%20')
    }
    $DstTextBox.Text = $txt
}

# configure Decode Button
$DecodeButton = New-Object System.Windows.Forms.Button
$DecodeButton.Location = New-Object System.Drawing.Point(100,30)
$DecodeButton.Size = New-Object System.Drawing.Size(80,30)
$DecodeButton.Text = "Decode"
$DecodeButton.Add_Click({decode($SrcTextBox, $DstTextBox)})
$Form.Controls.Add($DecodeButton)

# configure Encode Button
$EncodeButton = New-Object System.Windows.Forms.Button
$EncodeButton.Location = New-Object System.Drawing.Point(200,30)
$EncodeButton.Size = New-Object System.Drawing.Size(80,30)
$EncodeButton.Text = "Encode"
$EncodeButton.Add_Click({encode($SrcTextBox, $DstTextBox)})
$Form.Controls.Add($EncodeButton)

# desplay Form
$Form.Add_Shown({$Form.Activate()})
[void] $Form.ShowDialog()
