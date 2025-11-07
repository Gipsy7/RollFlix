#!/usr/bin/env python3
"""
Script para substituir .withOpacity() por .withValues() em massa
Correção para Flutter 3.32+ deprecation warning
"""

import os
import re
import sys
from pathlib import Path

def fix_with_opacity(file_path):
    """Substitui .withOpacity(valor) por .withValues(alpha: valor)"""
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()
        
        original_content = content
        
        # Regex para encontrar .withOpacity(X) onde X pode ser número ou variável
        # Exemplos:
        #   .withOpacity(0.5) -> .withValues(alpha: 0.5)
        #   .withOpacity(opacity) -> .withValues(alpha: opacity)
        pattern = r'\.withOpacity\(([^)]+)\)'
        replacement = r'.withValues(alpha: \1)'
        
        content = re.sub(pattern, replacement, content)
        
        # Conta quantas substituições foram feitas
        changes = len(re.findall(pattern, original_content))
        
        if content != original_content:
            with open(file_path, 'w', encoding='utf-8') as f:
                f.write(content)
            return changes
        
        return 0
    
    except Exception as e:
        print(f'❌ Erro ao processar {file_path}: {e}')
        return 0

def main():
    """Processa todos os arquivos .dart no projeto"""
    lib_path = Path('lib')
    
    if not lib_path.exists():
        print('❌ Diretório lib/ não encontrado. Execute este script na raiz do projeto Flutter.')
        sys.exit(1)
    
    print('🔍 Procurando arquivos .dart com .withOpacity()...\n')
    
    total_files = 0
    total_changes = 0
    
    # Percorre todos os arquivos .dart
    for dart_file in lib_path.rglob('*.dart'):
        changes = fix_with_opacity(dart_file)
        if changes > 0:
            total_files += 1
            total_changes += changes
            print(f'✅ {dart_file.relative_to(lib_path)}: {changes} substituição(ões)')
    
    print(f'\n{"="*60}')
    print(f'✨ Concluído!')
    print(f'📊 Estatísticas:')
    print(f'   - Arquivos modificados: {total_files}')
    print(f'   - Total de substituições: {total_changes}')
    print(f'{"="*60}\n')
    
    if total_changes > 0:
        print('🔄 Execute "flutter analyze" para verificar se todos os warnings foram corrigidos.')
    else:
        print('ℹ️  Nenhuma ocorrência de .withOpacity() encontrada.')

if __name__ == '__main__':
    main()
