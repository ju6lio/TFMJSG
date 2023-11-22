# PROYECTO: 1_serotipo3

USER: JULIO 
TUTOR: AIDA 
SERVER USER: PORTÁTIL JULIO

## 1.PREPARACION ARCHIVOS
FECHA: 22.11.2023

	export BASEDIR=/media/julio/WGSNM/WGS/P001serotipo3
	export BASENAME=P001serotipo3
	mkdir -p $BASEDIR/Reads_Illumina
	mkdir $BASEDIR/Listas
 
## 1.1. CREAR LISTAS
FECHA: 22.11.2023

	***Creamos las listas con los nombres de la carrera y los nombres nuevos
 	nano $BASEDIR/Listas/P001serotipo3OldNamesISCIII.txt
  	nano $BASEDIR/Listas/P001serotipo3NewNamesISCIII.txt

## 1.2. RENOMBAR READS
FECHA: 22.11.2023

	cd $BASEDIR/Reads_Illumina
	for f in * ; do mv "$f" "${f//_001/}" ; done

	set -- $( cat $BASEDIR/Listas/P001serotipo3NewNamesISCIII.txt)
	for N in `cat $BASEDIR/Listas/P001serotipo3OldNamesISCIII.txt`
	do
    		 mv $BASEDIR/Reads_Illumina/$N"_R1.fastq.gz" $BASEDIR/Reads_Illumina/$1"_R1.fastq.gz"
   		 mv $BASEDIR/Reads_Illumina/$N"_R2.fastq.gz" $BASEDIR/Reads_Illumina/$1"_R2.fastq.gz"
	shift
	done
 

## 1.3. CREACION LISTA FORMATO FOFN
FECHA: 22.11.2023

 	cd
 	conda activate bactopia
	bactopia prepare --path $BASEDIR/Reads_Illumina/ --genome-size 2000000 > $BASEDIR/Listas/P001serotipo3TodosISCIII.txt
 	conda deactivate

## 2. LANZAR ENSAMBLAJE + MÓDULO MERLIN
FECHA: 22.11.2023

	mkdir $BASEDIR/Contigs_Bactopia

	conda activate bactopia
	bactopia --samples $BASEDIR/Listas/P001serotipo3TodosISCIII.txt --ask_merlin --outdir $BASEDIR/Contigs_Bactopia -work-dir $BASEDIR/work
	conda deactivate
