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
    conda activate bactopia
    
    ***Una vez instalado
    conda activate bactopia
    bactopia
  ***
 
  bactopia --r1 Desktop/Wgs/pruebas8/5027_S47_R1_001.fastq.gz --r2 Desktop/Wgs/pruebas8/5027_S47_R2_001.fastq.gz 
  bactopia --r1 Desktop/Wgs/pruebas8/5027_S47_R1_001.fastq.gz --r2 Desktop/Wgs/pruebas8/5027_S47_R2_001.fastq.gz  --sample PRUEBA9SP --genome_size 2000000 --outdir Desktop/Wgs

