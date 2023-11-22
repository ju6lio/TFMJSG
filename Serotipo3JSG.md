# PROYECTO: 1_serotipo3

USER: JULIO 
TUTOR: AIDA 
SERVER USER: PORTÁTIL JULIO

## 1.PREPARACION ARCHIVOS
FECHA: 22.11.2023

	export BASEDIR=/media/julio/WGSNM/WGS/1_serotipo3
	export BASENAME=1_serotipo3
	mkdir -p $BASEDIR/Reads_Illumina
	mkdir $BASEDIR/Listas
 
 ## 1.1.CREACION LISTA FORMATO FOFN
FECHA: 22.11.2023

 	conda activate bactopia
	bactopia prepare --path $BASEDIR/Reads_Illumina/ --genome-size 2000000 > $BASEDIR/Listas/1_serotipo3_TodosISCIII.txt
 	conda deactivate

## 1.2. LANZAR ENSAMBLAJE + MÓDULO MERLIN
FECHA: 22.11.2023

	mkdir $BASEDIR/Contigs_Bactopia
	conda activate bactopia
	bactopia --samples $BASEDIR/Listas/1_serotipo3_TodosISCIII.txt --ask_merlin --outdir $BASEDIR/Contigs_Bactopia
	conda deactivate
