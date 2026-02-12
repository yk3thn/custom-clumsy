Write-Host "=== EXODUS RENAME SCRIPT ==="

$root = Get-Location

# File extensions we should NOT touch
$binaryExts = @(
    ".exe", ".dll", ".sys", ".lib", ".a", ".obj", ".pdb"
)

function Is-BinaryFile($path) {
    $ext = [System.IO.Path]::GetExtension($path).ToLower()
    return $binaryExts -contains $ext
}

# ---------- 1. REPLACE TEXT INSIDE FILES ----------
Get-ChildItem -Recurse -File | ForEach-Object {
    if (Is-BinaryFile $_.FullName) { return }

    try {
        $content = Get-Content $_.FullName -Raw -ErrorAction Stop
    } catch {
        return
    }

    $new = $content `
        -replace "EXODUS", "EXODUS" `
        -replace "EXODUS", "Exodus" `
        -replace "EXODUS", "exodus"

    if ($new -ne $content) {
        Set-Content $_.FullName $new -NoNewline
    }
}

# ---------- 2. RENAME FILES ----------
Get-ChildItem -Recurse -File | Sort-Object FullName -Descending | ForEach-Object {
    $newName = $_.Name `
        -replace "EXODUS", "EXODUS" `
        -replace "EXODUS", "Exodus" `
        -replace "EXODUS", "exodus"

    if ($newName -ne $_.Name) {
        Rename-Item $_.FullName $newName
    }
}

# ---------- 3. RENAME DIRECTORIES ----------
Get-ChildItem -Recurse -Directory | Sort-Object FullName -Descending | ForEach-Object {
    $newName = $_.Name `
        -replace "EXODUS", "EXODUS" `
        -replace "EXODUS", "Exodus" `
        -replace "EXODUS", "exodus"

    if ($newName -ne $_.Name) {
        Rename-Item $_.FullName $newName
    }
}

Write-Host "=== Rename complete ==="
