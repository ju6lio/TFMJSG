2 de noviembre de 2023

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
