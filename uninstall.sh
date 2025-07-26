#!/bin/bash

echo "UNINSTALLING SQL DEVELOPER..."

# Eliminar carpeta de instalación
if [ -d "$HOME/sqldeveloper" ]; then
    echo "REMOVING: $HOME/sqldeveloper"
    rm -rf "$HOME/sqldeveloper"
else
    echo "SKIPPED: $HOME/sqldeveloper not found"
fi

# Eliminar carpeta de configuración
if [ -d "$HOME/.sqldeveloper" ]; then
    echo "REMOVING: $HOME/.sqldeveloper"
    rm -rf "$HOME/.sqldeveloper"
else
    echo "SKIPPED: $HOME/.sqldeveloper not found"
fi

# Eliminar ícono de escritorio
desktop_file="$HOME/.local/share/applications/sqldeveloper.desktop"
if [ -f "$desktop_file" ]; then
    echo "REMOVING: $desktop_file"
    rm -f "$desktop_file"
else
    echo "SKIPPED: $desktop_file not found"
fi

# Actualizar base de datos de íconos del escritorio
echo "UPDATE DESKTOP ICONS"
update-desktop-database "$HOME/.local/share/applications/"

echo "SQL DEVELOPER UNINSTALLED SUCCESSFULLY."
