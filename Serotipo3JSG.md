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

FECHA: 23.11.2023

Creamos listas para el pangenoma

  	nano $BASEDIR/Listas/P001serotipo3roaryTODOS.txt
   
   	nano $BASEDIR/Listas/P001serotipo3roaryCC180.txt

    	nano $BASEDIR/Listas/P001serotipo3roaryCC260.txt

   
## 1.2. RENOMBAR READS
FECHA: 22.11.2023

	cd $BASEDIR/Reads_Illumina
	for f in * ; do mv "$f" "${f//_001/}" ; done
 	for f in * ; do mv "$f" "${f//_S*_R/_R}" ; done

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

### 2.1 COPIAR FICHERS FASTA A UNA CARPETA
FECHA 28.11.2023

 	mkdir $BASEDIR/Ensamblajes

	cp $BASEDIR/Contigs_Bactopia/*/main/assembler/*.fna.gz $BASEDIR/Ensamblajes
  	cd $BASEDIR/Ensamblajes
     	gzip -d *


## 3. ABRICATE
FECHA: 23.11.2023

Vamos a lanzar Abricate, con todas las bases de datos que tiene, para completar la información que hemos obtenido con el mlst PBPtyper, seroba, etc en el pipeline general

	bactopia --wf abricate --bactopia $BASEDIR/Contigs_Bactopia  --include $BASEDIR/Listas/P001serotipo3TodosISCIII.txt --abricate_db vfdb -work-dir $BASEDIR/work
	bactopia --wf abricate --bactopia $BASEDIR/Contigs_Bactopia  --include $BASEDIR/Listas/P001serotipo3TodosISCIII.txt --abricate_db card -work-dir $BASEDIR/work
	bactopia --wf abricate --bactopia $BASEDIR/Contigs_Bactopia  --include $BASEDIR/Listas/P001serotipo3TodosISCIII.txt --abricate_db argannot -work-dir $BASEDIR/work
 	bactopia --wf abricate --bactopia $BASEDIR/Contigs_Bactopia  --include $BASEDIR/Listas/P001serotipo3TodosISCIII.txt --abricate_db resfinder -work-dir $BASEDIR/work
   	bactopia --wf abricate --bactopia $BASEDIR/Contigs_Bactopia  --include $BASEDIR/Listas/P001serotipo3TodosISCIII.txt --abricate_db plasmidfinder -work-dir $BASEDIR/work

## 4. ROARY
## 4.1. ROARY TODOS
FECHA: 23.11.2023

	conda activate bactopia
	bactopia --wf pangenome --bactopia $BASEDIR/Contigs_Bactopia --include $BASEDIR/Listas/P001serotipo3roaryTODOS.txt --use_roary --i 70 --cd 100 --s -work-dir $BASEDIR/work  --cleanup_workdir
	conda deactivate

## 4.2. ROARY CC180
FECHA: 23.11.2023

	conda activate bactopia
	bactopia --wf pangenome --bactopia $BASEDIR/Contigs_Bactopia --include $BASEDIR/Listas/P001serotipo3roaryCC180.txt --use_roary --i 70 --cd 100 --s -work-dir $BASEDIR/work --cleanup_workdir
	conda deactivate

 ## 4.3. ROARY CC260
FECHA: 23.11.2023

	conda activate bactopia
	bactopia --wf pangenome --bactopia $BASEDIR/Contigs_Bactopia --include $BASEDIR/Listas/P001serotipo3roaryCC260.txt --use_roary --i 70 --cd 100 --s -work-dir $BASEDIR/work --cleanup_workdir
	conda deactivate

 ## 5. ROPROFILE
FECHA: 24.11.2023

PARA USAR EL SCRIPT PYTHON ROPROFILE HE TENIDO QUE CREAR UN ENVIRONMENT EN CONDA PARA QUE LO PUDIESE EJECUTAR CORRECTAMENTE

	conda create --name roProfile python=2.7 biopython matplotlib mpld3 pandas 

PARA EJECUTARLO
	
	export ROPROFILEDIR=/home/julio/NGSTOOLS/roProfile
 	mkdir -p $BASEDIR/RoProfile/RoProfileTodos-ISCIII-HUB/
  	mkdir -p $BASEDIR/RoProfile/GFFfiles
   
   	cp $BASEDIR/Contigs_Bactopia/*/main/annotator/prokka/*.gff.gz $BASEDIR/RoProfile/GFFfiles
    	cd $BASEDIR/RoProfile/GFFfiles
     	gzip -d *
    
	conda activate roProfile
 
	$ROPROFILEDIR/roProfile.py -r $BASEDIR/P001serotipo3/Contigs_Bactopia/bactopia-runs/pangenome-TODOS/roary/ -d $BASEDIR/RoProfile/GFFfiles/

	conda deactivate
 
## 6. SCOARY
FECHA: 24.11.2023

Para el scoary tenemos que crear un archivo .cvs con lo que queremos comparar. Creamos archivo csv para comprar CC180 y CC260, las cuatro cepas de distintos CCs serán 00

En Bactopia supuestamente se podía hacer el scoary, en documentación al buscar aparece pero en overview general y los modulos que dispone bactopia v3.3 mirado en la consola, no aparece ese modulo.

conda activate bactopia
bactopia --wf scoary --bactopia $BASEDIR/Contigs_Bactopia --include  $BASEDIR/Listas/P001serotipo3roaryTODOS.txt  --traits $BASEDIR/Listas/scoarytodos.csv 
conda deactivate

Instalamos scoary en PC y hacemos scoary con la herramienta directmente

	conda create --name scoary
 	sudo apt install scoary
  
	conda activate scoary
  	scoary -g $BASEDIR/Contigs_Bactopia/bactopia-runs/pangenome-TODOS/roary/gene_presence_absence.csv -t $BASEDIR/Listas/scoarytodos.csv -o $BASEDIR/
   	conda deactivate


## 7. SNIPPY + SNIPPY CORE + GUBBINS
## 7.1. SNIPPY + SNIPPY CORE + GUBBINS TODOS
FECHA: 30.11.2023
A partir de ahora vamos a añadir también la opción de --cleanup_workdir, para no tener que borrar manualmente la carpeta work

Hubo un error en el pipeline, del cuál levante el siguiente ticket: https://github.com/bactopia/bactopia/issues/465 y otro usuario me dio la solución temporal hasta que arreglen el error del pipeline:


I found the same error, I think there has to be an issue of dependencies, specially with libvcflib1. Nevertheless, I solve the problem installing in local again the libvcflib1.

apt-get update
apt-get install libvcflib1

I hope this will be helpful for you meanwhile the developers try to fix it :)

Volvemos a hacerlo:

 	conda activate bactopia
  
	bactopia --wf snippy --bactopia $BASEDIR/Contigs_Bactopia --include $BASEDIR/Listas/P001serotipo3roaryTODOS.txt --reference $BASEDIR/References/OXC141.gb --gubbin_opts	'--bootstrap 100 --transfer-bootstrap -f 40' -work-dir $BASEDIR/work --cleanup_workdir

 	conda deactivate
  
## 7.2. SNIPPY + SNIPPY CORE + GUBBINS CC180

Vamos a hacer el snippy, snippy core y gubbins del CC180

 	conda activate bactopia
  
	bactopia --wf snippy --bactopia $BASEDIR/Contigs_Bactopia --include $BASEDIR/Listas/P001serotipo3roaryCC180.txt --reference $BASEDIR/References/OXC141.gb --gubbin_opts	"--bootstrap 100 --transfer-bootstrap -f 40" -work-dir $BASEDIR/work --cleanup_workdir

 	conda deactivate
  

## 7.3. SNIPPY + SNIPPY CORE + GUBBINS CC260

Del CC180 





