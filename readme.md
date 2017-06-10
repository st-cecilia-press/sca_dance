## Minimum Entry

in ./dance_slug/metadata.yaml
```yaml
title: Dance Title
person: Anonymous
category: English Country
instructions:
- filename: instruction1.md
  instruction_type: reconstruction
```

instruction_type can be either 'reconstruction' or 'choreography'

current category list can be found here: http://stcpress.org/dance_categories

## Options for metadata.yaml only

Videos can be added directly to metadata.yaml. No correlation with other yaml files required.
```yaml
title: Dance Title
person: Anonymous
category: English Country
instructions:
- filename: instruction1.md
  instruction_type: reconstruction
  video:
  - name: Name of video
    youtube: LwTUpzrfNwQ
```

### sources.yaml and metadata.yaml

in ./sources.yaml
```yaml
- slug: chigi_manuscript
  title: Chigi Manuscript (1560s)
  dates:
  - 1560
  - 1569
- slug: playford_1651
  title: The English Dancing Master (1651)
  dates:
  - 1651
```
Sources can have one or two dates

in ./dance_slug/metadata.yaml
```yaml
- slug: playford_1651
  images:
  - url: http://www.pbm.com/~lindahl/playford_1651/103.png
    filename: gp_playford_facsimile.png
    name: Facsimile
    description: 
```
filename file must exist in ./dance_slug/
all of the images fields are optional

in ./alta_regina/metadata.yaml
```yaml
title: Alta Regina
person: Caroso
category: Italian Balli - 16th Century & Later
sources:
- slug: caroso_il_ballarino
  translations:
  - url: http://jducoeur.org/IlBallarino/Book2/Alta%20Regina.html
    name: Lady Clara Beaumont's Translation
```

You can have images or translations or both.

### media.yaml and metadata.yaml

in ./dance_slug/media.yaml
```yaml
sheet_music:
- slug: aaron_elkiss_alta_regina
  name: Aaron Elkiss's Arrangement
  music_files:
  - filename: alta_regina.pdf
    source: http://pennsicdance.aands.org/pennsic45/PennsicPile45.pdf
    name: Pennsic Pile Edition
```
file name file must be in ./dance_slug/ 

in ./dance_slug/metadata.yaml
```yaml
---
title: Alta Regina
person: Caroso
category: Italian Balli - 16th Century & Later
instructions:
- filename: terp.md
  person: ''
  instruction_type: reconstruction
  sheet_music:
  - aaron_elkiss_alta_regina
```

sheet_music elements must be slugs in the media.yaml

### adding ensembles and recordings
in ./ensembles.yaml
```yaml
- slug: peascod_gatherers
  name: The Peascod Gatherers
  description: Dance Band featuring Master Aaron Drummond (Aaron Elkiss) and Mistress Jadwiga Krzyzanowska (Monique Rio)
```

in ./dance_slug/media.yaml
```yaml
audio:
- slug: musica_subterranea_alta_regina
  youtube: z8D863TaHXM
  purchase_url: https://store.cdbaby.com/cd/musicasubterranea4
  ensemble: musica_subterranea
  file: music_file.mp3
```
If music file present, it must exist in ./dance_slug/

in ./dance_slug/metadata.yaml
```yaml
title: Alta Regina
person: Caroso
category: Italian Balli - 16th Century & Later
instructions:
- filename: terp.md
  person: ''
  instruction_type: reconstruction
  audio:
  - musica_subterranea_alta_regina
```

audio elements must be slugs in the media.yaml
