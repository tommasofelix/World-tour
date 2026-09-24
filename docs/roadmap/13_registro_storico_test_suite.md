# World-tour — Roadmap Modulare: Sezione 13

- File di origine: `docs/roadmap.md`
- Titolo: Registro Storico delle Suite di Test Convalidate
- Priorità Operativa: P13 - Qualità & Verifica

---

## 13. REGISTRO STORICO DELLE SUITE DI TEST CONVALIDATE (28/28 TEST SUITE)

A testimonianza della solidità tecnica delle fondamenta attuali, tutte le seguenti 28 suite di test automatizzati vengono eseguite in modalità headless con 0 errori a 0 ms:
1. `tests/test_formulas.gd`: test unitari su curve XP, formule qualità brani, concert score e bilanciamento.
2. `tests/test_time_system.gd`: test su orologio giornaliero, fasce orarie e stati IDLE/BUSY/PAUSED.
3. `tests/test_time_night_system.gd`: test su ciclo notturno a 22 ore, overtime progressivo, skip time e riposo anticipato.
4. `tests/test_vital_resources_system.gd`: test su triade risorse vitali (Energia, Stress, Morale), burnout e relax.
5. `tests/test_character_creation.gd`: test su creazione personaggio, background, tratti e avvio rapido.
6. `tests/test_end_day_system.gd`: test su ciclo di mezzanotte, spese fisse, decadimento e riposo notturno.
7. `tests/test_schedule_system.gd`: test su agenda, calendario a 28 giorni e prenotazione eventi.
8. `tests/test_localization.gd`: test su rilevamento lingua, dizionari speculari e segnali di cambio lingua.
9. `tests/test_music_system.gd`: test sulla pipeline di creazione brani, temi lirici e calcolo qualità.
10. `tests/test_advanced_crafting_system.gd`: test su temi lirici, sinergie tematiche e tratti canzone.
11. `tests/test_album_system.gd`: test su formati Singolo, EP e LP, concept artistici e vendite Day 1.
12. `tests/test_band_system.gd`: test su reclutamento band, ruoli, personalità, affinità, rispetto e revenue split.
13. `tests/test_concert_system.gd`: test sul motore concerti, affluenza, scaletta, stage events, merch ed encore.
14. `tests/test_economy_system.gd`: test su sussistenza, alloggi, bancarotta e compensi.
15. `tests/test_upgrades_system.gd`: test su UpgradesModal, 5 famiglie strumenti con comparatore e hardware studio.
16. `tests/test_travel_system.gd`: test sulla rete delle 16 città mondiali, affinità di genere e costi di viaggio.
17. `tests/test_tour_system.gd`: test su tournée multi-tappa, logistica veicoli, Day Off e accumulo Hype.
18. `tests/test_festival_system.gd`: test sui 16 festival estivi, slot orari, Battle of the Bands e mosse estreme.
19. `tests/test_social_media_system.gd`: test su BandFeed, viralità, shitstorm e social buzz.
20. `tests/test_advanced_social_system.gd`: test su weekly trends, live stream, Fan Club e raduni annuali.
21. `tests/test_chart_rival_system.gd`: test sulle 10 band rivali, Hit Parade Top 10 e conquista del #1.
22. `tests/test_media_and_rivals_system.gd`: test su media broadcaster, interviste, recensioni e classifiche territoriali.
23. `tests/test_industry_system.gd`: test su contratti Indie vs Major, anticipi, recoupment, manager e propria etichetta con roster attivo.
24. `tests/test_dilemma_system.gd`: test sui bivi etico-narrativi e scelte morali.
25. `tests/test_endgame_and_legacy_system.gd`: test su grandi arene, stadi, produzioni, certificazioni, awards e legacy finale.
26. `tests/test_v5_ui_overhaul.gd`: test sull'architettura HUD a 5 sezioni, Top Bar permanente e Menu Esc.
27. `tests/test_ui_audio_and_numpad_system.gd`: test su sound design procedurale in memoria, earcons, volume di sicurezza (<=0.75f), ducking automatico (40%), Numpad Navigation e statistiche di carriera.
28. `tests/test_endless_and_ngplus_system.gd`: test su modalità carriera infinita sandbox, New Game+ con erede musicale (Legacy Disciple), royalties passive del mentore e retrocompatibilità savegame.

