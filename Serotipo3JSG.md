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


El ensamblaje funciona sin problemas:

Completed at: 23-Nov-2023 05:35:44
Duration    : 13h 30m 1s
CPU hours   : 151.0
Succeeded   : 2'238

FECHA: 23.11.2023

Ensambla cada cepa entre 4-5 minutos. De los 175 genomas que metimos, ha tenido success ensamblado 171 de los 175. Había unas lecturas con muy poca calidad así que no es de extrañar.
Las cepas que no se ensamblaron fueron:

SPRLISCIII0739-09-> no hay lecturas suficientes, no llega al coverage mínimo de 10X
SPRLISCIII0941-08-> no hay lecturas sufucientes
SPRLISCIII5053-16-> no hay lecturas suficientes
SPRLISCIII6043-18-> read count error, no hay las mismas lecturas en R1 y R2, son muy diferentes los números. No sigue con el pipeline de ensamblaje.

La 6043 se vuelve a intentar:

	bactopia --r1 $BASEDIR/Reads_Illumina/SPRLISCIII6043-18_R1.fastq.gz --r2 $BASEDIR/Reads_Illumina/SPRLISCIII6043-18_R2.fastq.gz  --sample SPRLISCIII6043-18 --genome_size 2000000 --ask_merlin --outdir $BASEDIR/Contigs_Bactopia

Sigue dando el mismo error, así que no la podemos ensamblar y la descartamos del análisis.

La siguiente cepa:
GENOME	YEAR	AGE	LABORATORY	HOSPITAL	GPSC	CC	ST	aroE	gdh	gki	recP	spi	xpt	ddl
SPRLISCIII2374-10	2010	79,00	LRSP	LRSP	31	CC306	-	12	8	13	575?	16	4	20	
Era rara porque tenía un perfil de MLST que se asimilaba más al 1.
Al comprobar el seroba nos indica que es un serotipo 1 y que detecta contaminación. En el pneumocat se ve 99% serotipo 1 y 95% serotipo 3. Esto nos indica que ha habido una contaminación con otro neumo en la extracción. La descartamos para el análisis

## 3. ABRICATE
FECHA: 23.11.2023

Vamos a lanzar Abricate, con todas las bases de datos que tiene, para completar la información que hemos obtenido con el mlst PBPtyper, seroba, etc en el pipeline general

	bactopia --wf abricate --bactopia $BASEDIR/Contigs_Bactopia  --include $BASEDIR/Listas/P001serotipo3TodosISCIII.txt --abricate_db vfdb -work-dir $BASEDIR/work
	bactopia --wf abricate --bactopia $BASEDIR/Contigs_Bactopia  --include $BASEDIR/Listas/P001serotipo3TodosISCIII.txt --abricate_db card -work-dir $BASEDIR/work
	bactopia --wf abricate --bactopia $BASEDIR/Contigs_Bactopia  --include $BASEDIR/Listas/P001serotipo3TodosISCIII.txt --abricate_db argannot -work-dir $BASEDIR/work
 	bactopia --wf abricate --bactopia $BASEDIR/Contigs_Bactopia  --include $BASEDIR/Listas/P001serotipo3TodosISCIII.txt --abricate_db resfinder -work-dir $BASEDIR/work


 ncbi --csv > $BASEDIR/Abricate/ncbi.csv
cat $BASEDIR/Listas/L_Genomas_TodosISCIII.txt | parallel --jobs 2 abricate $BASEDIR/Contigs_INNUca/Fastas/$(echo {/}".fasta") --db card  --csv > $BASEDIR/Abricate/card.csv
cat $BASEDIR/Listas/L_Genomas_TodosISCIII.txt | parallel --jobs 2 abricate $BASEDIR/Contigs_INNUca/Fastas/$(echo {/}".fasta") --db plasmidfinder --csv > $BASEDIR/Abricate/plasmidfinder.csv
cat $BASEDIR/Listas/L_Genomas_TodosISCIII.txt | parallel --jobs 2 abricate $BASEDIR/Contigs_INNUca/Fastas/$(echo {/}".fasta") --db argannot --csv > $BASEDIR/Abricate/argannot.csv
cat $BASEDIR/Listas/L_Genomas_TodosISCIII.txt | parallel --jobs 2 abricate $BASEDIR/Contigs_INNUca/Fastas/$(echo {/}".fasta") --db resfinder --csv > $BASEDIR/Abricate/resfinder.csv
cat $BASEDIR/Listas/L_Genomas_TodosISCIII.txt | parallel --jobs 2 abricate $BASEDIR/Contigs_INNUca/Fastas/$(echo {/}".fasta") --db vfdb --csv >
