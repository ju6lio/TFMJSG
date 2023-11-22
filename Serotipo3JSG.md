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
 
## 1.1. RENOMBAR READS
FECHA: 22.11.2023

	cd $BASEDIR/Reads_Illumina
	for f in * ; do mv "$f" "${f//_001/}" ; done
	for f in * ; do mv "$f" "${f//_S*_R/_R}" ; done

	set -- $( cat $BASEDIR/Listas/L_Genomas_TodosISCIII.txt )
	for N in `cat $BASEDIR/Listas/L_Genomas_Oldnames.txt`
	do
    		 mv /dades/usrs_home/aida/$BASEDIR/Reads_Illumina/$N"_R1.fastq" /dades/usrs_home/aida/$BASEDIR/Reads_Illumina/$1"_R1.fastq"
   		 mv /dades/usrs_home/aida/$BASEDIR/Reads_Illumina/$N"_R2.fastq" /dades/usrs_home/aida/$BASEDIR/Reads_Illumina/$1"_R2.fastq"
	shift
	done
 

## 1.2. CREACION LISTA FORMATO FOFN
FECHA: 22.11.2023

 	conda activate bactopia
	bactopia prepare --path $BASEDIR/Reads_Illumina/ --fastq-ext '_001.fastq.gz' --genome-size 2000000 > $BASEDIR/Listas/1_serotipo3_TodosISCIII.txt
 	conda deactivate

## 1.2. LANZAR ENSAMBLAJE + MÓDULO MERLIN
FECHA: 22.11.2023

	mkdir $BASEDIR/Contigs_Bactopia
	conda activate bactopia
	bactopia --samples $BASEDIR/Listas/1_serotipo3_TodosISCIII.txt --ask_merlin --outdir $BASEDIR/Contigs_Bactopia
	conda deactivate
