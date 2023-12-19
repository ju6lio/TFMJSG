# PROYECTO: 58_SPNE_Serotipo8JSG
  USER: JULIO
  TUTOR: AIDA
  SERVER USER: AIDA

## 1.PREPARACION ARCHIVOS
	FECHA: 02.11.2023

	export BASEDIR=wgs/58_SPNE_Serotipo8JSG``
 	export BASENAME=58_SPNE_Serotipo8JSG
	mkdir -p $BASEDIR/Reads_Illumina
	mkdir $BASEDIR/Listas
  
### 1.1.CREACION LISTAS
	FECHA: 02.11.2023
  
 	nano $BASEDIR/Listas/L_Genomas_TodosISCIII.txt
	nano $BASEDIR/Listas/L_Genomas_Oldnames.txt

 	FECHA: 07.11.2023
  
 	nano $BASEDIR/Listas/L_Genomas_TodosISCIII-CC53.txt
  	nano $BASEDIR/Listas/L_Genomas_TodosISCIII-CC63.txt
	nano $BASEDIR/Listas/L_Genomas_TodosISCIII-CC404.txt

  	FECHA: 13.11.2023
  
 	nano $BASEDIR/Listas/L_Genomas_HUB-JAC.txt
  	nano $BASEDIR/Listas/L_Genomas_HUB-VFDB.txt

    	FECHA: 14.11.2023
  
 	nano $BASEDIR/Listas/L_Genomas_TodosISCIIIHUB-CC53.txt
  	nano $BASEDIR/Listas/L_Genomas_TodosISCIIIHUB-CC404.txt
	
## 2.READS
### 2.1.READS IMPORTADO SECUENCIADOS POR ISCIII

### 2.2.RENOMBRAR READS
#### 2.2.1.DESCOMPRIMIR
 	FECHA: 02.11.2023

  	gzip -d $BASEDIR/Reads_Illumina/*.gz

#### 2.2.1.RENOMBRAR
 	FECHA: 02.11.2023

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
 	
   	FECHA: 13.11.2023

 	cd $BASEDIR/Reads_Illumina
   	for f in * ; do mv "$f" "${f//_1/_R1}" ; done
       	for f in * ; do mv "$f" "${f//_2/_R2}" ; done

#### 2.2.2.COMPRIMIR
   	FECHA: 02.11.2023

   	cd $BASEDIR/Reads_Illumina
	ls *_R1.fastq | parallel --jobs 25 gzip -9 {/}
 	ls *_R2.fastq | parallel --jobs 25 gzip -9 {/}

#### 2.2.3. COPIAR READS Hospital Universitario Bellvitge (HUB)

   	FECHA: 13.11.2023

   	mkdir $BASEDIR/Reads_Illumina_HUB
    	mv $BASEDIR/Reads_Illumina/HUB* $BASEDIR/Reads_Illumina_HUB
	
## 3.ENSAMBLAJE INNUCA
   	FECHA: 02.11.2023	

	cat $BASEDIR/Listas/L_Genomas_TodosISCIII.txt | parallel --jobs 1 'docker run -u $(id -u):$(id -g) --rm -v /dades/usrs_home/aida:/data/ ummidock/innuca:4.2.0-05 INNUca.py -s "Streptococcus pneumoniae" -g 2.0 -f /data/$BASEDIR/Reads_Illumina/$(echo {/}"_1.fastq.gz") /data/$BASEDIR/Reads_Illumina/$(echo {/}"_2.fastq.gz") -j 60 --fastQCkeepFiles -o /data/$BASEDIR/Contigs_INNUca/{/}' 

   	FECHA: 06.11.2023
    	//Bad perGC quality, una de las cepas tuvimos que levantar la exception para que la ensamblase por mal GC %
     
	docker run -u $(id -u):$(id -g) --rm -v /dades/usrs_home/aida:/data/ ummidock/innuca:4.2.0-05 INNUca.py -s "Streptococcus pneumoniae" -g 2.0 -f /data/$BASEDIR/Reads_Illumina/SPRLISCIII0421-20_1.fastq.gz /data/$BASEDIR/Reads_Illumina/SPRLISCIII0421-20_2.fastq.gz -j 60 --skipFastQC -o /data/$BASEDIR/Contigs_INNUca/SPRLISCIII0421-20

    	FECHA: 13.11.2023	

	cat $BASEDIR/Listas/L_Genomas_HUB-JAC.txt | parallel --jobs 1 'docker run -u $(id -u):$(id -g) --rm -v /dades/usrs_home/aida:/data/ ummidock/innuca:4.2.0-05 INNUca.py -s "Streptococcus pneumoniae" -g 2.0 -f /data/$BASEDIR/Reads_Illumina_HUB/$(echo {/}"_1.fastq.gz") /data/$BASEDIR/Reads_Illumina_HUB/$(echo {/}"_2.fastq.gz") -j 60 --fastQCkeepFiles -o /data/$BASEDIR/Contigs_INNUca/{/}' 
 
### 3.1.CREAR FICHERO RESUMEN 
	FECHA: 06.11.2023
    
	mkdir $BASEDIR/Contigs_INNUca/Reports_INNUca
    
	cat $BASEDIR/Listas/L_Genomas_TodosISCIII.txt | parallel --jobs 1 cat $BASEDIR/Contigs_INNUca/{/}/com* >>  $BASEDIR/Contigs_INNUca/Reports_INNUca/Report_Combine_Innuca.txt
    
	cat $BASEDIR/Listas/L_Genomas_TodosISCIII.txt | parallel --jobs 1 cat $BASEDIR/Contigs_INNUca/{/}/sam* >> $BASEDIR/Contigs_INNUca/Reports_INNUca/Report_Sample_Innuca.txt

### 3.2.CREAR UNA CARPETA CON TODOS LOS FASTAS
	FECHA: 06.11.2023
    	
	mkdir $BASEDIR/Contigs_INNUca/Fastas
	cat $BASEDIR/Listas/L_Genomas_TodosISCIII.txt | parallel --jobs 2 cp $BASEDIR/Contigs_INNUca/{/}/{/}/*ed.fasta $BASEDIR/Contigs_INNUca/Fastas

#### 3.2.1.MOVER LOS ENSAMBLADOS DEL HUB-JAC A LA CARPETA 
	FECHA: 13.11.2023
    	cd
	cat $BASEDIR/Listas/L_Genomas_HUB-JAC.txt | parallel --jobs 2 cp $BASEDIR/Contigs_INNUca/{/}/{/}/*ed.fasta $BASEDIR/Contigs_INNUca/Fastas

### 3.3.RENOMBRAR FASTAS 
	FECHA: 06.11.2023
  
	cd $BASEDIR/Contigs_INNUca/Fastas
	for f in * ; do mv "$f" "${f//.contigs.length_GCcontent_kmerCov.mappingCov.polished/}" ; done

 #### 3.3.1.RENOMBRAR FASTAS 
	FECHA: 13.11.2023
  
	cd $BASEDIR/Contigs_INNUca/Fastas
	for f in * ; do mv "$f" "${f//.contigs.length_GCcontent_kmerCov.mappingCov.polished/}" ; done
	
### 3.4. ASSEMBLY-STATS
	FECHA: 06.11.2023

	cd 
	cat $BASEDIR/Listas/L_Genomas_TodosISCIII.txt | parallel --jobs 2 'assembly-stats -t $BASEDIR/Contigs_INNUca/Fastas/$(echo {/}".fasta") >> $BASEDIR/Contigs_INNUca/Reports_INNUca/Assembly-Stat.txt'

## 4.ABRICATE
	FECHA: 06.11.2023
	
	mkdir $BASEDIR/Abricate
	
	conda activate abricate
	cat $BASEDIR/Listas/L_Genomas_TodosISCIII.txt | parallel --jobs 2 abricate $BASEDIR/Contigs_INNUca/Fastas/$(echo {/}".fasta") --db ncbi --csv > $BASEDIR/Abricate/ncbi.csv
	cat $BASEDIR/Listas/L_Genomas_TodosISCIII.txt | parallel --jobs 2 abricate $BASEDIR/Contigs_INNUca/Fastas/$(echo {/}".fasta") --db card  --csv > $BASEDIR/Abricate/card.csv
	cat $BASEDIR/Listas/L_Genomas_TodosISCIII.txt | parallel --jobs 2 abricate $BASEDIR/Contigs_INNUca/Fastas/$(echo {/}".fasta") --db plasmidfinder --csv > $BASEDIR/Abricate/plasmidfinder.csv
	cat $BASEDIR/Listas/L_Genomas_TodosISCIII.txt | parallel --jobs 2 abricate $BASEDIR/Contigs_INNUca/Fastas/$(echo {/}".fasta") --db argannot --csv > $BASEDIR/Abricate/argannot.csv
	cat $BASEDIR/Listas/L_Genomas_TodosISCIII.txt | parallel --jobs 2 abricate $BASEDIR/Contigs_INNUca/Fastas/$(echo {/}".fasta") --db resfinder --csv > $BASEDIR/Abricate/resfinder.csv
 	cat $BASEDIR/Listas/L_Genomas_TodosISCIII.txt | parallel --jobs 2 abricate $BASEDIR/Contigs_INNUca/Fastas/$(echo {/}".fasta") --db vfdb --csv > $BASEDIR/Abricate/vfdb.csv 
	conda deactivate

 	FECHA: 13.11.2023

 	cat $BASEDIR/Listas/L_Genomas_HUB-VFDB.txt | parallel --jobs 2 abricate $BASEDIR/Contigs_INNUca/Fastas/$(echo {/}".fasta") --db vfdb --csv > $BASEDIR/Abricate/vfdbhub.csv

## 5.MLST
	FECHA: 06.11.2023

	conda activate mlst
	cat $BASEDIR/Listas/L_Genomas_TodosISCIII.txt | parallel --jobs 2 mlst $BASEDIR/Contigs_INNUca/Fastas/$(echo {/}".fasta") --legacy --scheme spneumoniae --csv >> $BASEDIR/Abricate/mlst.csv
	conda deactivate

	FECHA: 13.11.2023

	conda activate mlst
	mlst $BASEDIR/Contigs_INNUca/Fastas/HUB* --legacy --scheme spneumoniae --csv >> $BASEDIR/Abricate/mlst-HUB.csv
	conda deactivate

## 6.PROKKA	
 	FECHA: 06.11.2023
  
	mkdir $BASEDIR/Reference_Genomes
 	conda activate prokka
   
	cat $BASEDIR/Listas/L_Genomas_TodosISCIII.txt | parallel --jobs 1 prokka --outdir $BASEDIR/Prokka/{/} --proteins $BASEDIR/Reference_Genomes/R6.faa --force --centre ISCIII --genus Streptococcus --species pneumoniae --strain {/} --cpus 30 --prefix {/} --locustag $(echo {/})p --addgenes --usegenus --rfam --increment 10 --mincontiglen 1 --gcode 11 --kingdom Bacteria $BASEDIR/Contigs_INNUca/Fastas/$(echo {/}).fasta
	
 	conda deactivate

### 6.1.PROKKA HUB	
 	FECHA: 13.11.2023
  
	conda activate prokka
   
	cat $BASEDIR/Listas/L_Genomas_HUB-VFDB.txt | parallel --jobs 1 prokka --outdir $BASEDIR/Prokka/{/} --proteins $BASEDIR/Reference_Genomes/R6.faa --force --centre HUB --genus Streptococcus --species pneumoniae --strain {/} --cpus 30 --prefix {/} --locustag $(echo {/})p --addgenes --usegenus --rfam --increment 10 --mincontiglen 1 --gcode 11 --kingdom Bacteria $BASEDIR/Contigs_INNUca/Fastas/$(echo {/}).fasta
	
 	conda deactivate

## 7.ROARY
### 7.1. TODO
	FECHA: 07.11.2023
 
	mkdir -p $BASEDIR/Roary/RoaryTodos-ISCIII/
 	cat $BASEDIR/Listas/L_Genomas_Todos.txt | parallel --jobs 1 cp $BASEDIR/Prokka/{/}/$(echo {/}).gff $BASEDIR/Roary/RoaryTodos/GFF
 	conda activate roary
	roary $BASEDIR/Prokka/*/*.gff -f $BASEDIR/Roary/RoaryTodos-ISCIII/ -e -n -v -s -p 30 -i 70

### 7.2.CC53
	FECHA: 07.11.2023
 
	mkdir -p $BASEDIR/Roary/RoaryTodos-ISCIII-CC53/GFF
 	cat $BASEDIR/Listas/L_Genomas_TodosISCIII-CC53.txt | parallel --jobs 1 cp $BASEDIR/Prokka/{/}/$(echo {/}).gff $BASEDIR/Roary/RoaryTodos-ISCIII-CC53/GFF
 	conda activate roary
	roary $BASEDIR/Roary/RoaryTodos-ISCIII-CC53/GFF/*.gff -f $BASEDIR/Roary/RoaryTodos-ISCIII-CC53/ -e -n -v -s -p 30 -i 70

 ### 7.3.CC63
	FECHA: 07.11.2023
 
	mkdir -p $BASEDIR/Roary/RoaryTodos-ISCIII-CC63/GFF
 	cat $BASEDIR/Listas/L_Genomas_TodosISCIII-CC63.txt | parallel --jobs 1 cp $BASEDIR/Prokka/{/}/$(echo {/}).gff $BASEDIR/Roary/RoaryTodos-ISCIII-CC63/GFF
 	conda activate roary
	roary $BASEDIR/Roary/RoaryTodos-ISCIII-CC63/GFF/*.gff -f $BASEDIR/Roary/RoaryTodos-ISCIII-CC63/ -e -n -v -s -p 30 -i 70

 ### 7.4.CC404
	FECHA: 07.11.2023
 
	mkdir -p $BASEDIR/Roary/RoaryTodos-ISCIII-CC404/GFF
 	cat $BASEDIR/Listas/L_Genomas_TodosISCIII-CC404.txt | parallel --jobs 1 cp $BASEDIR/Prokka/{/}/$(echo {/}).gff $BASEDIR/Roary/RoaryTodos-ISCIII-CC404/GFF
 	conda activate roary
	roary $BASEDIR/Roary/RoaryTodos-ISCIII-CC404/GFF/*.gff -f $BASEDIR/Roary/RoaryTodos-ISCIII-CC404/ -e -n -v -s -p 30 -i 70

 ### 7.5. TODO+HUB
	FECHA: 13.11.2023
 
	mkdir -p $BASEDIR/Roary/RoaryTodos-ISCIII-HUB/
 	
  	conda activate roary
	roary $BASEDIR/Prokka/*/*.gff -f $BASEDIR/Roary/RoaryTodos-ISCIII-HUB/ -e -n -v -s -p 30 -i 70 -cd 100

### 7.2.CC53+HUB
	FECHA: 13.11.20233
 
	mkdir -p $BASEDIR/Roary/RoaryTodos-ISCIII-CC53-HUB/GFF
 	cat $BASEDIR/Listas/L_Genomas_TodosISCIIIHUB-CC53.txt | parallel --jobs 1 cp $BASEDIR/Prokka/{/}/$(echo {/}).gff $BASEDIR/Roary/RoaryTodos-ISCIII-CC53-HUB/GFF
 	conda activate roary
	roary $BASEDIR/Roary/RoaryTodos-ISCIII-CC53-HUB/GFF/*.gff -f $BASEDIR/Roary/RoaryTodos-ISCIII-CC53-HUB/ -e -n -v -s -p 30 -i 70 -cd 100

 ### 7.7.CC404+HUB
	FECHA: 13.11.20233
 
	mkdir -p $BASEDIR/Roary/RoaryTodos-ISCIII-CC404-HUB/GFF
 	cat $BASEDIR/Listas/L_Genomas_TodosISCIIIHUB-CC404.txt | parallel --jobs 1 cp $BASEDIR/Prokka/{/}/$(echo {/}).gff $BASEDIR/Roary/RoaryTodos-ISCIII-CC404-HUB/GFF
 	conda activate roary
	roary $BASEDIR/Roary/RoaryTodos-ISCIII-CC404-HUB/GFF/*.gff -f $BASEDIR/Roary/RoaryTodos-ISCIII-CC404-HUB/ -e -n -v -s -p 30 -i 70 -cd 100
 
  ### 7.8.CC63 PARÁMETRO 100
	FECHA: 13.11.2023
 
	mkdir -p $BASEDIR/Roary/RoaryTodos-ISCIII-CC63/GFF
 	cat $BASEDIR/Listas/L_Genomas_TodosISCIII-CC63.txt | parallel --jobs 1 cp $BASEDIR/Prokka/{/}/$(echo {/}).gff $BASEDIR/Roary/RoaryTodos-ISCIII-CC63/GFF
 	conda activate roary
	roary $BASEDIR/Roary/RoaryTodos-ISCIII-CC63/GFF/*.gff -f $BASEDIR/Roary/RoaryTodos-ISCIII-CC63/ -e -n -v -s -p 30 -i 70 -cd 100

## 8.CERRAR GENOMAS PARA UTILIZAR DE REFERENCIA 
### 8.1. SPRLISCIII0370-07 CON TVO_1901948 DE REFERENCIA (NZ_CP035241)
	FECHA: 08.11.2023
	
 	export MAUVE=/dades/ngstools/mauve/ 

	java -Xmx500m -cp $MAUVE/mauve_snapshot_2015-02-13/Mauve.jar org.gel.mauve.contigs.ContigOrderer -output /dades/usrs_home/aida/wgs/58_SPNE_Serotipo8JSG/Reference_Genomes -ref /dades/usrs_home/aida/wgs/58_SPNE_Serotipo8JSG/Reference_Genomes/TVO_1901948.gbk -draft /dades/usrs_home/aida/wgs/58_SPNE_Serotipo8JSG/Contigs_INNUca/Fastas/SPRLISCIII0370-07.fasta



#### 8.1.1. Anotar con PROKKA
	FECHA: 08.11.2023

	mkdir $BASEDIR/Reference_Genomes/Prokka
 	conda activate prokka
   
	prokka --outdir $BASEDIR/Reference_Genomes/Prokka/SPRLISCIII0370-07sNs --proteins $BASEDIR/Reference_Genomes/R6.faa --force --centre ISCIII --genus Streptococcus --species pneumoniae --strain SPRLISCIII0370-07sNs --cpus 30 --prefix SPRLISCIII0370-07sNs --locustag SPRLISCIII0370-07sNsp --compliant --addgenes --usegenus --rfam --increment 10 --mincontiglen 1 --gcode 11 --kingdom Bacteria $BASEDIR/Reference_Genomes/SPRLISCIII0370-07sNs.fasta
 

 ### 8.2. SPRLISCIII0930-08 CON TVO_1901948 DE REFERENCIA (NZ_CP035241)
	FECHA: 08.11.2023
	
 	export MAUVE=/dades/ngstools/mauve/ 

	java -Xmx500m -cp $MAUVE/mauve_snapshot_2015-02-13/Mauve.jar org.gel.mauve.contigs.ContigOrderer -output /dades/usrs_home/aida/wgs/58_SPNE_Serotipo8JSG/Reference_Genomes -ref /dades/usrs_home/aida/wgs/58_SPNE_Serotipo8JSG/Reference_Genomes/TVO_1901948.gbk -draft /dades/usrs_home/aida/wgs/58_SPNE_Serotipo8JSG/Contigs_INNUca/Fastas/SPRLISCIII0930-08.fasta

 #### 8.2.1. Anotar con PROKKA
	FECHA: 08.11.2023

	mkdir $BASEDIR/Reference_Genomes/Prokka
 	conda activate prokka
   
	prokka --outdir $BASEDIR/Reference_Genomes/Prokka/SPRLISCIII0930-08sNs --proteins $BASEDIR/Reference_Genomes/R6.faa --force --centre ISCIII --genus Streptococcus --species pneumoniae --strain SPRLISCIII0930-08sNs --cpus 30 --prefix SPRLISCIII0930-08sNs --locustag SPRLISCIII0930-08sNsp --compliant --addgenes --usegenus --rfam --increment 10 --mincontiglen 1 --gcode 11 --kingdom Bacteria $BASEDIR/Reference_Genomes/SPRLISCIII0930-08sNs.fasta

 ### 8.3. SPRLISCIII0973-08 CON TVO_1901948 DE REFERENCIA (NZ_CP035241)
	FECHA: 08.11.2023
	
 	export MAUVE=/dades/ngstools/mauve/ 

	java -Xmx500m -cp $MAUVE/mauve_snapshot_2015-02-13/Mauve.jar org.gel.mauve.contigs.ContigOrderer -output /dades/usrs_home/aida/wgs/58_SPNE_Serotipo8JSG/Reference_Genomes -ref /dades/usrs_home/aida/wgs/58_SPNE_Serotipo8JSG/Reference_Genomes/TVO_1901948.gbk -draft /dades/usrs_home/aida/wgs/58_SPNE_Serotipo8JSG/Contigs_INNUca/Fastas/SPRLISCIII0973-08.fasta


 #### 8.3.1. Anotar con PROKKA
	FECHA: 08.11.2023

	mkdir $BASEDIR/Reference_Genomes/Prokka
 	conda activate prokka
   
	prokka --outdir $BASEDIR/Reference_Genomes/Prokka/SPRLISCIII0973-08sNs --proteins $BASEDIR/Reference_Genomes/R6.faa --force --centre ISCIII --genus Streptococcus --species pneumoniae --strain SPRLISCIII0973-08sNs --cpus 2 --prefix SPRLISCIII0973-08sNs --locustag SPRLISCIII0973-08sNsp --compliant --addgenes --usegenus --rfam --increment 10 --mincontiglen 1 --gcode 11 --kingdom Bacteria $BASEDIR/Reference_Genomes/SPRLISCIII0973-08sNs.fasta
 
## 9.SNIPPY

### 9.1.MAPEAR
#### 9.1.1.CC404 SPRLISCIII0930-08_shorted_100Ns(REF)
	FECHA: 08.11.2023

 	conda activate snippy
	mkdir -p $BASEDIR/Snippy/Snippy-CC404-ISCIII
	
	cat $BASEDIR/Listas/L_Genomas_TodosISCIII-CC404.txt | parallel --jobs 1 snippy --cpus 30 --outdir $BASEDIR/Snippy/Snippy-CC404-ISCIII/{/}  --ref $BASEDIR/Reference_Genomes/Prokka/SPRLISCIII0930-08sNs/SPRLISCIII0930-08sNs.gbf --R1 $BASEDIR/Reads_Illumina/$(echo {/})_1.fastq.gz --R2 $BASEDIR/Reads_Illumina/$(echo {/})_2.fastq.gz

#### 9.1.2.CC53 SPRLISCIII0973-08_shorted_100Ns(REF)
	FECHA: 09.11.2023

 	conda activate snippy
	mkdir -p $BASEDIR/Snippy/Snippy-CC53-ISCIII
	
	cat $BASEDIR/Listas/L_Genomas_TodosISCIII-CC53.txt | parallel --jobs 1 snippy --cpus 30 --outdir $BASEDIR/Snippy/Snippy-CC53-ISCIII/{/}  --ref $BASEDIR/Reference_Genomes/Prokka/SPRLISCIII0973-08sNs/SPRLISCIII0973-08sNs.gbf --R1 $BASEDIR/Reads_Illumina/$(echo {/})_1.fastq.gz --R2 $BASEDIR/Reads_Illumina/$(echo {/})_2.fastq.gz

#### 9.1.3.CC63 SPRLISCIII0370-07_shorted_100Ns(REF)
	FECHA: 09.11.2023

 	conda activate snippy
	mkdir -p $BASEDIR/Snippy/Snippy-CC63-ISCIII
	
	cat $BASEDIR/Listas/L_Genomas_TodosISCIII-CC63.txt | parallel --jobs 1 snippy --cpus 30 --outdir $BASEDIR/Snippy/Snippy-CC63-ISCIII/{/}  --ref $BASEDIR/Reference_Genomes/Prokka/SPRLISCIII0370-07sNs/SPRLISCIII0370-07sNs.gbf --R1 $BASEDIR/Reads_Illumina/$(echo {/})_1.fastq.gz --R2 $BASEDIR/Reads_Illumina/$(echo {/})_2.fastq.gz
 
#### 9.1.4.CC404 SPRLISCIII0930-08_shorted_100Ns(REF) del HUB
	FECHA: 13.11.2023

 	conda activate snippy
	
 	cat $BASEDIR/Listas/L_Genomas_HUB-CC404.txt | parallel --jobs 1 snippy --cpus 30 --outdir $BASEDIR/Snippy/Snippy-CC404-ISCIII/{/}  --ref $BASEDIR/Reference_Genomes/Prokka/SPRLISCIII0930-08sNs/SPRLISCIII0930-08sNs.gbf --R1 $BASEDIR/Reads_Illumina_HUB/$(echo {/})_R1.fastq.gz --R2 $BASEDIR/Reads_Illumina_HUB/$(echo {/})_R2.fastq.gz

#### 9.1.5.CC53 SPRLISCIII0973-08_shorted_100Ns(REF) del HUB
	FECHA: 09.11.2023

	conda activate snippy
		
	cat $BASEDIR/Listas/L_Genomas_HUB-CC53.txt| parallel --jobs 1 snippy --cpus 30 --outdir $BASEDIR/Snippy/Snippy-CC53-ISCIII/{/}  --ref $BASEDIR/Reference_Genomes/Prokka/SPRLISCIII0973-08sNs/SPRLISCIII0973-08sNs.gbf --R1 $BASEDIR/Reads_Illumina_HUB/$(echo {/})_*1.fastq.gz --R2 $BASEDIR/Reads_Illumina_HUB/$(echo {/})_*2.fastq.gz

#### 9.1.6.CC63 SPRLISCIII0973-08_shorted_100Ns(REF) ISCIII+HUB
	FECHA: 09.11.2023

 	conda activate snippy
	mkdir -p $BASEDIR/Snippy/Snippy-CC63-ISCIII-refCC53
	
	cat $BASEDIR/Listas/L_Genomas_TodosISCIII-CC63.txt | parallel --jobs 1 snippy --cpus 30 --outdir $BASEDIR/Snippy/Snippy-CC63-ISCIII-refCC53/{/}  --ref $BASEDIR/Reference_Genomes/Prokka/SPRLISCIII0973-08sNs/SPRLISCIII0973-08sNs.gbf --R1 $BASEDIR/Reads_Illumina/$(echo {/})_*1.fastq.gz --R2 $BASEDIR/Reads_Illumina/$(echo {/})_*2.fastq.gz
 
#### 9.1.7.CC404 SPRLISCIII0973-08_shorted_100Ns(REF) ISCIII+HUB
	FECHA: 13.11.2023

 	conda activate snippy

  	mkdir -p $BASEDIR/Snippy/Snippy-CC404-ISCIII-refCC53
	
 	cat $BASEDIR/Listas/L_Genomas_TodosISCIIIHUB-CC404.txt | parallel --jobs 1 snippy --cpus 30 --outdir $BASEDIR/Snippy/Snippy-CC404-ISCIII-refCC53/{/}  --ref $BASEDIR/Reference_Genomes/Prokka/SPRLISCIII0973-08sNs/SPRLISCIII0973-08sNs.gbf --R1 $BASEDIR/Reads_Illumina*/$(echo {/})_*1.fastq.gz --R2 $BASEDIR/Reads_Illumina*/$(echo {/})_*2.fastq.gz


  
### 9.2.CREAR UN ALINEAMIENTO CON SNIPPY-CORE
#### 9.2.1.CC404 SPRLISCIII0930-08_shorted_100Ns(REF) 
	FECHA: 08.11.2023
		
	snippy-core --prefix $BASEDIR/Snippy/Snippy-CC404-ISCIII/$BASENAME-CC404-ISCIII $BASEDIR/Snippy/Snippy-CC404-ISCIII/* --ref $BASEDIR/Reference_Genomes/Prokka/SPRLISCIII0930-08sNs/SPRLISCIII0930-08sNs.gbf

#### 9.2.2.CC53 SPRLISCIII0973-08_shorted_100Ns(REF) 
	FECHA: 09.11.2023
		
	snippy-core --prefix $BASEDIR/Snippy/Snippy-CC53-ISCIII/$BASENAME-CC53-ISCIII $BASEDIR/Snippy/Snippy-CC53-ISCIII/* --ref $BASEDIR/Reference_Genomes/Prokka/SPRLISCIII0973-08sNs/SPRLISCIII0973-08sNs.gbf

 #### 9.2.3.CC63 SPRLISCIII0370-07_shorted_100Ns(REF) 
	FECHA: 09.11.2023
		
	snippy-core --prefix $BASEDIR/Snippy/Snippy-CC63-ISCIII/$BASENAME-CC63-ISCIII $BASEDIR/Snippy/Snippy-CC63-ISCIII/* --ref $BASEDIR/Reference_Genomes/Prokka/SPRLISCIII0370-07sNs/SPRLISCIII0370-07sNs.gbf

#### 9.2.4.CC404 SPRLISCIII0930-08_shorted_100Ns(REF) ISCIII+HUB
	FECHA: 13.11.2023
		
	snippy-core --prefix $BASEDIR/Snippy/Snippy-CC404-ISCIII/$BASENAME-CC404-ISCIII+HUB $BASEDIR/Snippy/Snippy-CC404-ISCIII/[A-Z]* --ref $BASEDIR/Reference_Genomes/Prokka/SPRLISCIII0930-08sNs/SPRLISCIII0930-08sNs.gbf

#### 9.2.5.CC53 SPRLISCIII0973-08_shorted_100Ns(REF) ISCIII+HUB
	FECHA: 13.11.2023
		
	snippy-core --prefix $BASEDIR/Snippy/Snippy-CC53-ISCIII/$BASENAME-CC53-ISCIII+HUB $BASEDIR/Snippy/Snippy-CC53-ISCIII/[A-Z]* --ref $BASEDIR/Reference_Genomes/Prokka/SPRLISCIII0973-08sNs/SPRLISCIII0973-08sNs.gbf

#### 9.2.6.CC53+CC404+CC63 SPRLISCIII0973-08_shorted_100Ns(REF) ISCIII+HUB
	FECHA: 14.11.2023

 	mkdir -p $BASEDIR/Snippy/Snippy-Todos-ISCIII+HUB-refCC53
		
	snippy-core --prefix $BASEDIR/Snippy/Snippy-Todos-ISCIII+HUB-refCC53/Snippy-Todos-ISCIII+HUB-refCC53 $BASEDIR/Snippy/*CC53*/[A-Z]* --ref $BASEDIR/Reference_Genomes/Prokka/SPRLISCIII0973-08sNs/SPRLISCIII0973-08sNs.gbf
 
### 9.3.REMPLAZAR LOS - POR N CON CONVERT_GAPS_TO_N
#### 9.3.1.CC404 SPRLISCIII0930-08_shorted_100Ns(REF) 
	FECHA: 08.11.2023
	
	export GAPSNDIR=/dades/ngstools/gap2N
	python3 $GAPSNDIR/convert_gaps_to_Ns.py -i $BASEDIR/Snippy/Snippy-CC404-ISCIII/$BASENAME-CC404-ISCIII.full.aln -o  $BASEDIR/Snippy/Snippy-CC404-ISCIII/$BASENAME-CC404-ISCIII_full_N.fasta

 #### 9.3.2.CC53 SPRLISCIII0973-08_shorted_100Ns(REF) 
	FECHA: 09.11.2023
	
	export GAPSNDIR=/dades/ngstools/gap2N
	python3 $GAPSNDIR/convert_gaps_to_Ns.py -i $BASEDIR/Snippy/Snippy-CC53-ISCIII/$BASENAME-CC53-ISCIII.full.aln -o  $BASEDIR/Snippy/Snippy-CC53-ISCIII/$BASENAME-CC53-ISCIII_full_N.fasta

 #### 9.3.3.CC63 SPRLISCIII0370-07_shorted_100Ns(REF)  
	FECHA: 09.11.2023
	
	export GAPSNDIR=/dades/ngstools/gap2N
	python3 $GAPSNDIR/convert_gaps_to_Ns.py -i $BASEDIR/Snippy/Snippy-CC63-ISCIII/$BASENAME-CC63-ISCIII.full.aln -o  $BASEDIR/Snippy/Snippy-CC63-ISCIII/$BASENAME-CC63-ISCIII_full_N.fasta

 #### 9.3.4.CC404 SPRLISCIII0930-08_shorted_100Ns(REF) ISCIII+HUB
	FECHA: 08.11.2023
	
	export GAPSNDIR=/dades/ngstools/gap2N
	python3 $GAPSNDIR/convert_gaps_to_Ns.py -i $BASEDIR/Snippy/Snippy-CC404-ISCIII/$BASENAME-CC404-ISCIII+HUB.full.aln -o  $BASEDIR/Snippy/Snippy-CC404-ISCIII/$BASENAME-CC404-ISCIII+HUB_full_N.fasta

 #### 9.3.5.CC53 SPRLISCIII0973-08_shorted_100Ns(REF) ISCIII+HUB
	FECHA: 09.11.2023
	
	export GAPSNDIR=/dades/ngstools/gap2N
	python3 $GAPSNDIR/convert_gaps_to_Ns.py -i $BASEDIR/Snippy/Snippy-CC53-ISCIII/$BASENAME-CC53-ISCIII+HUB.full.aln -o  $BASEDIR/Snippy/Snippy-CC53-ISCIII/$BASENAME-CC53-ISCIII+HUB_full_N.fasta
 
 #### 9.3.5.CC53+CC404+CC63 SPRLISCIII0973-08_shorted_100Ns(REF) ISCIII+HUB
	FECHA: 14.11.2023
	
	export GAPSNDIR=/dades/ngstools/gap2N
	python3 $GAPSNDIR/convert_gaps_to_Ns.py -i $BASEDIR/Snippy/Snippy-Todos-ISCIII+HUB-refCC53/Snippy-Todos-ISCIII+HUB-refCC53.full.aln -o  $BASEDIR/Snippy/Snippy-Todos-ISCIII+HUB-refCC53/Snippy-Todos-ISCIII+HUB-refCC53_full_N.fasta


### 9.4.CONTAR N POR CEPA
#### 9.4.1.CC404 SPRLISCIII0930-08_shorted_100Ns(REF) 
	FECHA: 08.11.2023

	export COUNTNDIR=/dades/ngstools/count_N
	perl $COUNTNDIR/count_N.pl < $BASEDIR/Snippy/Snippy-CC404-ISCIII/$BASENAME-CC404-ISCIII_full_N.fasta > $BASEDIR/Snippy/Snippy-CC404-ISCIII/$BASENAME-CC404-ISCIII_full_N_countN.txt

#### 9.4.2.CC53 SPRLISCIII0973-08_shorted_100Ns(REF)  
	FECHA: 09.11.2023

	export COUNTNDIR=/dades/ngstools/count_N
	perl $COUNTNDIR/count_N.pl < $BASEDIR/Snippy/Snippy-CC53-ISCIII/$BASENAME-CC53-ISCIII_full_N.fasta > $BASEDIR/Snippy/Snippy-CC53-ISCIII/$BASENAME-CC53-ISCIII_full_N_countN.txt

 #### 9.4.3.CC63 SPRLISCIII0370-07_shorted_100Ns(REF) 
	FECHA: 09.11.2023

	export COUNTNDIR=/dades/ngstools/count_N
	perl $COUNTNDIR/count_N.pl < $BASEDIR/Snippy/Snippy-CC63-ISCIII/$BASENAME-CC63-ISCIII_full_N.fasta > $BASEDIR/Snippy/Snippy-CC63-ISCIII/$BASENAME-CC63-ISCIII_full_N_countN.txt

 #### 9.4.4.CC404 SPRLISCIII0930-08_shorted_100Ns(REF) ISCIII+HUB
	FECHA: 08.11.2023

	export COUNTNDIR=/dades/ngstools/count_N
	perl $COUNTNDIR/count_N.pl < $BASEDIR/Snippy/Snippy-CC404-ISCIII/$BASENAME-CC404-ISCIII+HUB_full_N.fasta > $BASEDIR/Snippy/Snippy-CC404-ISCIII/$BASENAME-CC404-ISCIII+HUB_full_N_countN.txt

#### 9.4.5.CC53 SPRLISCIII0973-08_shorted_100Ns(REF) ISCIII+HUB
	FECHA: 09.11.2023

	export COUNTNDIR=/dades/ngstools/count_N
	perl $COUNTNDIR/count_N.pl < $BASEDIR/Snippy/Snippy-CC53-ISCIII/$BASENAME-CC53-ISCIII+HUB_full_N.fasta > $BASEDIR/Snippy/Snippy-CC53-ISCIII/$BASENAME-CC53-ISCIII+HUB_full_N_countN.txt

#### 9.4.5.CC53+CC404+CC63 SPRLISCIII0973-08_shorted_100Ns(REF) ISCIII+HUB
	FECHA: 14.11.2023

	export COUNTNDIR=/dades/ngstools/count_N
	perl $COUNTNDIR/count_N.pl < $BASEDIR/Snippy/Snippy-Todos-ISCIII+HUB-refCC53/Snippy-Todos-ISCIII+HUB-refCC53_full_N.fasta > $BASEDIR/Snippy/Snippy-Todos-ISCIII+HUB-refCC53/Snippy-Todos-ISCIII+HUB-refCC53_full_N_countN.txt
 
### 9.5.Eliminar ficheros snps.bam \\PENDIENTE DE BORRAR DEL SERVIDOR
	FECHA: xx.06.2023
	
	cd $BASEDIR/Snippy/RefT3T1/
	rm */snps.bam


## 10.GUBBINS

### 10.1.CC404 SPRLISCIII0930-08_shorted_100Ns(REF) 
	FECHA: 08.11.2023
	
	conda activate new-gubbins (v3.0.0)
	mkdir -p $BASEDIR/Gubbins/Gubbins-CC404-ISCIII
	run_gubbins.py $BASEDIR/Snippy/Snippy-CC404-ISCIII/$BASENAME-CC404-ISCIII_full_N.fasta -p $BASEDIR/Gubbins/Gubbins-CC404-ISCIII/$BASENAME-CC404-ISCIII_full_N.gubbinsv3 --bootstrap 100 --transfer-bootstrap -f 40 -c 30 -v

 ### 10.2.CC53 SPRLISCIII0973-08_shorted_100Ns(REF)  
	FECHA: 09.11.2023
	
	conda activate new-gubbins (v3.0.0)
	mkdir $BASEDIR/Gubbins/Gubbins-CC53-ISCIII
	run_gubbins.py $BASEDIR/Snippy/Snippy-CC53-ISCIII/$BASENAME-CC53-ISCIII_full_N.fasta -p $BASEDIR/Gubbins/Gubbins-CC53-ISCIII/$BASENAME-CC53-ISCIII_full_N.gubbinsv3 --bootstrap 100 --transfer-bootstrap -f 40 -c 30 -v

### 10.3.CC63 SPRLISCIII0370-07_shorted_100Ns(REF) 
	FECHA: 08.11.2023
	
	conda activate new-gubbins (v3.0.0)
	mkdir $BASEDIR/Gubbins/Gubbins-CC63-ISCIII
	run_gubbins.py $BASEDIR/Snippy/Snippy-CC63-ISCIII/$BASENAME-CC63-ISCIII_full_N_woref.fasta -p $BASEDIR/Gubbins/Gubbins-CC63-ISCIII/$BASENAME-CC63-ISCIII_full_N.gubbinsv3 --bootstrap 100 --transfer-bootstrap -f 40 -c 30 -v

### 10.4.CC404 SPRLISCIII0930-08_shorted_100Ns(REF) ISCIII+HUB
	FECHA: 13.11.2023
	
	conda activate new-gubbins (v3.0.0)
	mkdir -p $BASEDIR/Gubbins/Gubbins-CC404-ISCIII+HUB
	run_gubbins.py $BASEDIR/Snippy/Snippy-CC404-ISCIII/$BASENAME-CC404-ISCIII_HUB_full_N_woref.fasta -p $BASEDIR/Gubbins/Gubbins-CC404-ISCIII+HUB/$BASENAME-CC404-ISCIII+HUB_full_N.gubbinsv3 --bootstrap 100 --transfer-bootstrap -f 40 -c 30 -v

### 10.5.CC53 SPRLISCIII0973-08_shorted_100Ns(REF) ISCIII+HUB
	FECHA: 13.11.2023
	
	conda activate new-gubbins (v3.0.0)
	mkdir $BASEDIR/Gubbins/Gubbins-CC53-ISCIII+HUB
	run_gubbins.py $BASEDIR/Snippy/Snippy-CC53-ISCIII/$BASENAME-CC53-ISCIII_HUB_full_N_woref.fasta -p $BASEDIR/Gubbins/Gubbins-CC53-ISCIII+HUB/$BASENAME-CC53-ISCIII+HUB_full_N.gubbinsv3 --bootstrap 100 --transfer-bootstrap -f 40 -c 30 -v

### 10.6.CC53+CC404+CC63 SPRLISCIII0973-08_shorted_100Ns(REF) ISCIII+HUB
	FECHA: 13.11.2023
	
	conda activate new-gubbins (v3.0.0)
 
	mkdir $BASEDIR/Gubbins/Gubbins-Todos-ISCIII+HUB-refCC53
	run_gubbins.py $BASEDIR/Snippy/Snippy-Todos-ISCIII+HUB-refCC53/Snippy-Todos-ISCIII_HUB-refCC53_full_N_woref.fasta -p $BASEDIR/Gubbins/Gubbins-Todos-ISCIII+HUB-refCC53/Todos-ISCIII+HUB-refCC53_full_N_woref.gubbinsv3 --bootstrap 100 --transfer-bootstrap -f 40 -c 30 -v

## 11.ROPROFILE
	FECHA: 16.11.2023
	
	$ROPROFILEDIR/roProfile.py -r $BASEDIR/Roary/RoaryTodos-ISCIII-HUB/ -d $BASEDIR/Roary/RoaryTodos-ISCIII-HUB/GFF/ -g
	export ROPROFILEDIR=/dades/ngstools/roProfile
	mkdir -p $BASEDIR/RoProfile/RoProfileTodos-ISCIII-HUB/ 
	
	mv sequences $BASEDIR/RoProfile/RoProfileTodos-ISCIII-HUB/
	mv fre* $BASEDIR/RoProfile/RoProfileTodos-ISCIII-HUB/
	mv pan* $BASEDIR/RoProfile/RoProfileTodos-ISCIII-HUB/ 
	mv rem* $BASEDIR/RoProfile/RoProfileTodos-ISCIII-HUB/
	mv run* $BASEDIR/RoProfile/RoProfileTodos-ISCIII-HUB/ 
	mv cle* $BASEDIR/RoProfile/RoProfileTodos-ISCIII-HUB/ 

### 11.1.SEPARAR LOS GENES QUE SON EXCLUSIVOS DE CADA COMPLEJO
	FECHA: 20.11.2023
 
	mkdir -p $BASEDIR/RoProfile/RoProfileTodos-ISCIII-HUB/PRESENTCC404
   	mkdir -p $BASEDIR/RoProfile/RoProfileTodos-ISCIII-HUB/ABSENTCC404
    	mkdir -p $BASEDIR/RoProfile/RoProfileTodos-ISCIII-HUB/PRESENTCC53
   	mkdir -p $BASEDIR/RoProfile/RoProfileTodos-ISCIII-HUB/ABSENTCC53
    	mkdir -p $BASEDIR/RoProfile/RoProfileTodos-ISCIII-HUB/PRESENTCC63
   	mkdir -p $BASEDIR/RoProfile/RoProfileTodos-ISCIII-HUB/ABSENTCC63
 
	cat $BASEDIR/Listas/L_Genes_CC53_AUSENTES.txt | parallel --jobs 25 cp $BASEDIR/RoProfile/RoProfileTodos-ISCIII-HUB/sequences/"accessory."$(echo {/})".fasta" $BASEDIR/RoProfile/RoProfileTodos-ISCIII-HUB/ABSENTCC53
	cat $BASEDIR/Listas/L_Genes_CC53_PRESENTES.txt | parallel --jobs 25 cp $BASEDIR/RoProfile/RoProfileTodos-ISCIII-HUB/sequences/"accessory."$(echo {/})".fasta" $BASEDIR/RoProfile/RoProfileTodos-ISCIII-HUB/PRESENTCC53
	cat $BASEDIR/Listas/L_Genes_CC63_AUSENTES.txt | parallel --jobs 25 cp $BASEDIR/RoProfile/RoProfileTodos-ISCIII-HUB/sequences/"accessory."$(echo {/})".fasta" $BASEDIR/RoProfile/RoProfileTodos-ISCIII-HUB/ABSENTCC63
	cat $BASEDIR/Listas/L_Genes_CC63_PRESENTES.txt | parallel --jobs 25 cp $BASEDIR/RoProfile/RoProfileTodos-ISCIII-HUB/sequences/"accessory."$(echo {/})".fasta" $BASEDIR/RoProfile/RoProfileTodos-ISCIII-HUB/PRESENTCC63
	cat $BASEDIR/Listas/L_Genes_CC404_AUSENTES.txt | parallel --jobs 25 cp $BASEDIR/RoProfile/RoProfileTodos-ISCIII-HUB/sequences/"accessory."$(echo {/})".fasta" $BASEDIR/RoProfile/RoProfileTodos-ISCIII-HUB/ABSENTCC404
	cat $BASEDIR/Listas/L_Genes_CC404_PRESENTES.txt | parallel --jobs 25 cp $BASEDIR/RoProfile/RoProfileTodos-ISCIII-HUB/sequences/"accessory."$(echo {/})".fasta" $BASEDIR/RoProfile/RoProfileTodos-ISCIII-HUB/PRESENTCC404
	

### 11.2.CREAR UN FICHERO CON TODOS LOS GENES
	FECHA: 20.11.2023

#### 11.2.1.CC53
	cd $BASEDIR/RoProfile/RoProfileTodos-ISCIII-HUB/ABSENTCC53

	export SAMPLES=`ls *fasta`
	
	for SAMPLE in $SAMPLES
	do 
		export NAME=">"$SAMPLE"_"
		sed -i "s/>/${NAME}/g" $SAMPLE
	done

	cat * >> ABSENTCC53.fasta

 	cd $BASEDIR/RoProfile/RoProfileTodos-ISCIII-HUB/PRESENTCC53

	export SAMPLES=`ls *fasta`
	
	for SAMPLE in $SAMPLES
	do 
		export NAME=">"$SAMPLE"_"
		sed -i "s/>/${NAME}/g" $SAMPLE
	done
	
	cat * >> PRESENT53.fasta

#### 11.2.2.CC63

	cd $BASEDIR/RoProfile/RoProfileTodos-ISCIII-HUB/ABSENTCC63

	export SAMPLES=`ls *fasta`
	
	for SAMPLE in $SAMPLES
	do 
		export NAME=">"$SAMPLE"_"
		sed -i "s/>/${NAME}/g" $SAMPLE
	done

	cat * >> ABSENTCC63.fasta

 	cd $BASEDIR/RoProfile/RoProfileTodos-ISCIII-HUB/PRESENTCC63

	export SAMPLES=`ls *fasta`
	
	for SAMPLE in $SAMPLES
	do 
		export NAME=">"$SAMPLE"_"
		sed -i "s/>/${NAME}/g" $SAMPLE
	done

	cat * >> PRESENT63.fasta
 
#### 11.2.3.CC404
	
	cd $BASEDIR/RoProfile/RoProfileTodos-ISCIII-HUB/ABSENTCC404

	export SAMPLES=`ls *fasta`
	
	for SAMPLE in $SAMPLES
	do 
		export NAME=">"$SAMPLE"_"
		sed -i "s/>/${NAME}/g" $SAMPLE
	done

	cat * >> ABSENTCC404.fasta

 	cd $BASEDIR/RoProfile/RoProfileTodos-ISCIII-HUB/PRESENTCC404

	export SAMPLES=`ls *fasta`
	
	for SAMPLE in $SAMPLES
	do 
		export NAME=">"$SAMPLE"_"
		sed -i "s/>/${NAME}/g" $SAMPLE
	done

	cat * >> PRESENT404.fasta

 
## 11.SCOARY
### 11.1.CC53+CC404+CC63 SPRLISCIII0973-08_shorted_100Ns(REF) ISCIII+HUB
	FECHA: 17.11.2023

 	mkdir -p $BASEDIR/Scoary/ScoaryTodos-ISCIII-HUB
	conda activate scoary 
	scoary -g $BASEDIR/Roary/RoaryTodos-ISCIII-HUB/gene_presence_absence.csv -t $BASEDIR/Scoary/ScoaryTodos-ISCIII-HUB/TraitsCC.csv -o $BASEDIR/Scoary/ScoaryTodos-ISCIII-HUB --threads 1

 
## 12. GENES CAPSULA S8
### 12.1 MAPEAR READS A CLUSTER CAPSULAR S8

 	FECHA: 09.11.2023

 	conda activate snippy

  	mkdir -p $BASEDIR/Snippy/CapsulaS8ISCIII
	
 	cat $BASEDIR/Listas/L_Genomas_TodosISCIII.txt | parallel --jobs 1 snippy --cpus 30 --outdir $BASEDIR/Snippy/CapsulaS8ISCIII/{/}  --ref $BASEDIR/Reference_Genomes/CR931644.gbf --R1 $BASEDIR/Reads_Illumina*/$(echo {/})_*1.fastq.gz --R2 $BASEDIR/Reads_Illumina*/$(echo {/})_*2.fastq.gz


### 12.2.CREAR UN ALINEAMIENTO CON SNIPPY-CORE
		
	snippy-core --prefix $BASEDIR/Snippy/CapsulaS8ISCIII/$BASENAME-ISCIII $BASEDIR/Snippy/CapsulaS8ISCIII/* --ref $BASEDIR/Reference_Genomes/CR931644.gbf


## 13. PIPELINE BACTOPIA
	FECHA: 22.11.2023

### 13.1 PREPARAR LISTA DE LECTURAS EN FORMATO BACTOPIA
	FECHA: 22.11.2023
 
	conda activate bactopia-aida
	bactopia prepare --path $BASEDIR/Reads_Illumina/ --genome-size 2000000 > $BASEDIR/Listas/L_Genomas_BactopiaTodosISCIII.txt
	conda deactivate

### 13.2 LANZAR ENSAMBLAJE + MÓDULO MERLIN (INCLUYE SHOVILLE + FASTQC + MLST + ARMFINDERPLUS + MODULOS ESTREPTOS (PBPTYPER, PNEUMOCAT, SEROBA  Y DOS MÓDULOS DE S. suis y S. pyogenes)) 
	FECHA: 22.11.2023
 
 	mkdir  $BASEDIR/Contigs_Bactopia
  
	conda activate bactopia
	bactopia --samples $BASEDIR/Listas/L_Genomas_BactopiaTodosISCIII.txt --ask_merlin --outdir $BASEDIR/Contigs_Bactopia --cleanup_workdir --max_cpus 1 --max_memory 100 -qs 28
	conda deactivate

 	FECHA: 29.11.2023
 
 	mkdir  $BASEDIR/Contigs_Bactopia2
  
	conda activate bactopia-aida
	bactopia --samples $BASEDIR/Listas/L_Genomas_BactopiaTodosISCIII.txt --ask_merlin --outdir $BASEDIR/Contigs_Bactopia2 --cleanup_workdir --max_cpus 30 --max_memory 100
	conda deactivate

 ### 13.3 RESUMEN CALIDAD ENSAMBLAJES

	bactopia summary \ 
 	--bactopia-path $BASEDIR/Contigs_Bactopia

  
