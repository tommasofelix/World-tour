# tools/split_roadmap.py
# Script di utilità per suddividere docs/roadmap.md nelle sue 13 sezioni modulari in docs/roadmap/

import os
import re

source_path = "docs/roadmap.md"
target_dir = "docs/roadmap"
os.makedirs(target_dir, exist_ok=True)

with open(source_path, "r", encoding="utf-8") as f:
    lines = f.readlines()

print(f"Righe totali lette da {source_path}: {len(lines)}")

# Definizione dei marcatori delle sezioni principali
sections_def = [
    (0, "## INTRODUZIONE & GUIDA ALLA COMPILAZIONE", "00_introduzione_e_guida.md", "Introduzione & Guida alla Compilazione", "P0 - Riferimento Metodologico"),
    (1, "## 1. IDENTIT", "01_identita_personaggio_routine_e_risorse.md", "Identità del Musicista, Creazione Personaggio, Routine & Risorse", "P1 - Fondamenta Core Loop"),
    (2, "## 2. CREATIVIT", "02_creativita_musicale_scrittura_e_produzione.md", "Creatività Musicale, Scrittura Brani & Produzione Discografica", "P2 - Loop Discografico"),
    (3, "## 3. LA BAND", "03_band_reclutamento_dinamiche_e_revenue_split.md", "La Band, Reclutamento, Dinamiche Relazionali & Revenue Split", "P3 - Loop Sociale/Band"),
    (4, "## 4. STRUMENTI MUSICALI", "04_strumenti_sala_prove_home_studio_e_upgrades.md", "Strumenti Musicali, Sala Prove, Home Studio & Upgrades Hub", "P4 - Crescita Materiale"),
    (5, "## 5. CONCERTI DAL VIVO", "05_concerti_locali_scaletta_e_pubblico.md", "Concerti dal Vivo, Locali, Scaletta & Pubblico", "P5 - Performance Live"),
    (6, "## 6. GEOGRAFIA", "06_geografia_metropoli_e_tournee.md", "Geografia, Metropoli & Tournée", "P6 - Espansione Territoriale"),
    (7, "## 7. GRANDI FESTIVAL ESTIVI", "07_grandi_festival_estivi.md", "Grandi Festival Estivi all'Aperto", "P7 - Eventi Speciali"),
    (8, "## 8. SOCIAL MEDIA", "08_social_media_fan_engagement_e_viralita.md", "Social Media, Fan Engagement & Viralità (BandFeed)", "P8 - Comunicazione & Buzz"),
    (9, "## 9. L'INDUSTRIA MUSICALE", "09_industria_musicale_contratti_e_management.md", "L'Industria Musicale, Contratti & Management", "P9 - Business & Contratti"),
    (10, "## 10. ARTISTI RIVALI", "10_artisti_rivali_e_classifiche_musicali.md", "Artisti Rivali, Hit Parade & Classifiche Musicali", "P10 - Competizione & Classifiche"),
    (11, "## 11. ENDGAME", "11_endgame_grandi_stadi_e_legacy_mondiale.md", "Endgame, Grandi Stadi & Legacy Mondiale", "P11 - Consacrazione Finale"),
    (12, "## 12. ARCHITETTURA UI", "12_architettura_ui_accessibilita_nvda_e_sound_design.md", "Architettura UI, Accessibilità NVDA & Sound Design", "P12 - Interfaccia & Audio"),
    (13, "## 13. REGISTRO STORICO", "13_registro_storico_test_suite.md", "Registro Storico delle Suite di Test Convalidate", "P13 - Qualità & Verifica"),
]

# Troviamo gli indici di riga per ogni sezione
found_sections = []
for sec_num, marker, fname, title, priority in sections_def:
    idx = -1
    for i, line in enumerate(lines):
        if line.strip().startswith(marker):
            idx = i
            break
    if idx == -1:
        raise ValueError(f"Marcatore non trovato: {marker}")
    found_sections.append((idx, sec_num, fname, title, priority))

# Header globale del documento originale (righe prima di ## INTRODUZIONE)
file_header = "".join(lines[:found_sections[0][0]])

# Salvataggio di ciascuna sezione
manifest = []
total_written_lines = 0

for i in range(len(found_sections)):
    start_idx = found_sections[i][0]
    if i + 1 < len(found_sections):
        end_idx = found_sections[i+1][0]
    else:
        end_idx = len(lines)
    
    sec_num, fname, title, priority = found_sections[i][1], found_sections[i][2], found_sections[i][3], found_sections[i][4]
    sec_lines = lines[start_idx:end_idx]
    
    # Se è la sezione 0 (Introduzione), includiamo anche l'intestazione del file
    if sec_num == 0:
        content = file_header + "".join(sec_lines)
    else:
        header_comment = f"# World-tour — Roadmap Modulare: Sezione {sec_num}\n\n- File di origine: `docs/roadmap.md`\n- Titolo: {title}\n- Priorità Operativa: {priority}\n\n---\n\n"
        content = header_comment + "".join(sec_lines)
    
    out_file = os.path.join(target_dir, fname)
    with open(out_file, "w", encoding="utf-8") as f_out:
        f_out.write(content)
    
    line_count = len(content.splitlines())
    print(f"Creato: {fname} (Righe: {line_count}) - {title} [{priority}]")
    manifest.append((fname, title, priority, line_count))
    total_written_lines += len(sec_lines)

print(f"\nTotale righe estratte: {total_written_lines + found_sections[0][0]} / {len(lines)}")

# Creazione del README.md coordinatore in docs/roadmap/
readme_content = """# World-tour — Mappa Modulare della Roadmap di Gioco

- Autori del progetto: Luca & Holy Diver
- Assistente AI: Antigravity (Senior AI Pair Programmer)
- Posizione cartella: `docs/roadmap/`
- Documento sorgente consolidato: [`docs/roadmap.md`](../roadmap.md)
- Scopo: Suddivisione modulare e tematica della Roadmap Globale in file snelli, ordinati per argomento e priorità operativa di implementazione.

---

## 1. PRINCIPIO D'ORDINE & PRIORITÀ OPERATIVE PER L'ALPHA

Questa cartella scompone la monumentale Roadmap di World-tour in moduli indipendenti e navigabili agilmente con screen reader NVDA (tramite scorciatoie a tastiera e salti tra intestazioni `H`).

L'ordinamento segue la naturale catena di valore del gioco (dalle fondamenta del musicista all'Endgame):

"""

for fname, title, priority, count in manifest:
    readme_content += f"- **[{title}](./{fname})**  \n  *Priorità*: `{priority}` | *Righe*: {count}  \n\n"

readme_content += """---

## 2. MODALITÀ DI CONSULTAZIONE & AGGIORNAMENTO

1. **Lettura Lineare**: Ciascun file conserva rigorosamente la formattazione lineare per NVDA, senza diagrammi 2D né tabelle complesse.
2. **Spazio per i Dettagli di Luca**: In ogni file è preservata l'area dedicata in cui Luca aggiunge regole, varianti, dialoghi e parametri.
3. **Sincronizzazione**: Qualsiasi modifica specialistica applicata in questi file può essere consultata direttamente senza dover scorrere l'intero documento di 11.600 righe.
"""

readme_path = os.path.join(target_dir, "README.md")
with open(readme_path, "w", encoding="utf-8") as f_readme:
    f_readme.write(readme_content)

print(f"Creato README.md in {readme_path}")
