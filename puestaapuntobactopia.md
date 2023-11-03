
## INSTALAR BACTOPIA

    ***https://bactopia.github.io/v3.0.0/installation/#optional-install-conda-via-mambaforge
    create -n bactopia -c conda-forge -c bioconda bactopia

    ***Una vez instalado
    conda activate bactopia
    bactopia

## Prueba 1 Bactopia

    ***Vamos a ensamblar una cepa utilizando el pipeline bactopia
    mkdir Desktop/Wgs/pruebas8
    ***copiamos los paired-end reads de illumina en la carpeta y utilizamos el bactopia
    
    ***Activamos el bactopia
    conda activate bactopia
    
    ***Lo usamos
    bactopia --r1 Desktop/Wgs/pruebas8/5027_S47_R1_001.fastq.gz --r2 Desktop/Wgs/pruebas8/5027_S47_R2_001.fastq.gz 
    ***ASÍ DA ERROR le faltan datos de introducción

    ***nombramos a la Sample, ponemos el tamaño del genoma y el directorio donde guardar el output:
    
    bactopia --r1 Desktop/Wgs/pruebas8/5027_S47_R1_001.fastq.gz --r2 Desktop/Wgs/pruebas8/5027_S47_R2_001.fastq.gz  --sample PRUEBA9SP --genome_size 2000000 --outdir Desktop/Wgs

    ***Se ensambla correctamente después de esto, tiene un genoma ensamblado de calidad, además está el output del ARMfinder, está anotado en el PROKKA. En este caso tenemos todo el genoma en 27 contings que nos indica calidad y además son contings de gran tamaño

## Prueba 2 Bactopia

    ***Vamos a ensamblar la misma cepa pero en este caso vamos a intentar utilizar los modulos específicos de S. pneumoniae

    ***Se intentaron utilizar las herramientas por separado pero con el input de una sola cepa no sale, posteriormente me doy cuenta que si en el workflow general del ensamblaje activo merlin
    ***además del ensamblaje y todas las herramientas que ya utilizaba,manda a identificar el genero de la bacteria del input, y al identificarla como Streptococcus hará directamente 
    ***el analisis directo de especie (correrá también el modulo de emmtyper de S. pyogenes pero nos da igual, porque correr el pbptyper el seroba y pneumocat de neumo).

    bactopia --wf seroba --bactopia Desktop/Wgs/pruebas8/PRUEBA9SP/ --sample PRUEBA9SP 
    ***aquí no reconocía los archivos aunque se utilizan los comandos especificados en la información del programa

    ***Vamos a realizar el comando de antes, pero esta vez añadimos --ask_merlin, que llamará al programa, hará identificación de género y correrá herramientas específicas.

    bactopia --r1 Desktop/Wgs/prueba2s8/5027_S47_R1_001.fastq.gz --r2 Desktop/Wgs/prueba2s8/5027_S47_R2_001.fastq.gz  --sample PRUEBA2SPS8 --genome_size 2000000 --ask_merlin --outdir Desktop/Wgs/prueba2s8/

    ***Todos los outputs salen bien, nos da el serotipo correcto (serotipo 8) y hasta el tipado de las PBPs

## Prueba 3 Bactopia

    ***Ahora vamos a meterle más de un input, en la documentación viene que tenemos que crear un archivo FOFN

    ***Bactopia tiene una herramienta integrada que te crea el archivo FOFN (delimitado por tabuladores) con la información de tus archivos fasta. ASi que lo primero es preparar el archivo FOFN:

     bactopia prepare --path Desktop/Wgs/prueba3s8/ --fastq-ext '_001.fastq.gz' --genome-size 2000000 --species "Streptococcus pneumoniae" > Desktop/Wgs/prueba3s8/prueba3s8.txt

     ***YA tenemos creado nuestro archivo FOFN, podremos correr bactopia de varias cepas

     bactopia --samples Desktop/Wgs/prueba3s8/prueba3s8.txt --ask_merlin

     ***Se me ha olvidado poner el directorio del output. Además, no nos sale los merged results

     actopia prepare --path Desktop/Wgs/prueba3s8/ --fastq-ext '_001.fastq.gz' --genome-size 2000000 > Desktop/Wgs/prueba3s8/prueba3s8.txt

     bactopia --samples Desktop/Wgs/prueba3s8/prueba3s8.txt --ask_merlin --outdir Desktop/Wgs/prueba3s8/

     ***Tarda en ensamblarse las tres cepas 11 minutos, muy poco tiempo. En este caso tenemos el output directory correcto, lo que observo es que seroba solo aparece un dato, no aparece dato por cepa en merged results y además en pneumocat no aparece merged results. Le voy a preguntar a Aida


     


     




    
