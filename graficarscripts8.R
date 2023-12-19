library(ggplot2)

setwd("/home/julio/Documents/WGSNM/FiguraS8roary")

conserved_todos = colMeans(read.table("number_of_conserved_genes.Rtab"))
total_todos  = colMeans(read.table("number_of_genes_in_pan_genome.Rtab"))
resta_todos = total_todos-conserved_todos

genes_todos = data.frame(genes_to_genomes = c(conserved_todos ,total_todos),
                         genomes = c(c(1:length(conserved_todos)),c(1:length(conserved_todos ))),
                         Key = c(rep("Conserved genes",length(conserved_todos)), rep("Total genes",length(total_todos))))
genes_todos$serotype<-"Serotype todos"

resta_todosdf = data.frame(genes_to_genomes= resta_todos, genomes= c(1:length(resta_todos)), Key= rep("Resta genes", length(resta_todos)))
resta_todosdf$serotype <- "Serotype todos"

#CC53

conserved_CC53 = colMeans(read.table("number_of_conserved_genes_CC53.Rtab"))
total_CC53 = colMeans(read.table("number_of_genes_in_pan_genome_CC53.Rtab"))
resta_CC53 = total_CC53-conserved_CC53

genes_CC53 = data.frame( genes_to_genomes = c(conserved_CC53,total_CC53),
                         genomes = c(c(1:length(conserved_CC53)),c(1:length(conserved_CC53))),
                         Key = c(rep("Conserved genes",length(conserved_CC53)), rep("Total genes",length(total_CC53))))

genes_CC53$serotype<-"Serotype CC53"

resta_CC53df = data.frame(genes_to_genomes= resta_CC53, genomes= c(1:length(resta_CC53)), Key= rep("Resta genes", length(resta_CC53)))
resta_CC53df$serotype <- "Serotype CC53"

#CC63

conserved_CC63 = colMeans(read.table("number_of_conserved_genes _CC63.Rtab"))
total_CC63 = colMeans(read.table("number_of_genes_in_pan_genome_CC63.Rtab"))
resta_CC63 = total_CC63-conserved_CC63

genes_CC63 = data.frame( genes_to_genomes = c(conserved_CC63,total_CC63),
                         genomes = c(c(1:length(conserved_CC63)),c(1:length(conserved_CC63))),
                         Key = c(rep("Conserved genes",length(conserved_CC63)), rep("Total genes",length(total_CC63))))

genes_CC63$serotype<-"Serotype CC63"

resta_CC63df = data.frame(genes_to_genomes= resta_CC63, genomes= c(1:length(resta_CC63)), Key= rep("Resta genes", length(resta_CC63)))
resta_CC63df$serotype <- "Serotype CC63"

#CC404

conserved_CC404 = colMeans(read.table("number_of_conserved_genes_CC404.Rtab"))
total_CC404 = colMeans(read.table("number_of_genes_in_pan_genome_CC404.Rtab"))
resta_CC404 = total_CC404-conserved_CC404

genes_CC404 = data.frame( genes_to_genomes = c(conserved_CC404,total_CC404),
                          genomes = c(c(1:length(conserved_CC404)),c(1:length(conserved_CC404))),
                          Key = c(rep("Conserved genes",length(conserved_CC404)), rep("Total genes",length(total_CC404))))

genes_CC404$serotype<-"Serotype CC404"


resta_CC404df = data.frame(genes_to_genomes= resta_CC404, genomes= c(1:length(resta_CC404)), Key= rep("Resta genes", length(resta_CC404)))
resta_CC404df$serotype <- "Serotype CC404"


genes<-rbind(genes_todos,genes_CC53,genes_CC63,genes_CC404)


ggplot(data = genes_CC53, aes(x = genomes, y = genes_to_genomes, group = Key, linetype=Key,colour=serotype,size=serotype)) +
  geom_line()+
  geom_line(data = genes_CC63, aes(x = genomes, y = genes_to_genomes, group = Key, linetype=Key,colour=serotype,size=serotype))+ 
  geom_line(data = genes_CC404, aes(x = genomes, y = genes_to_genomes, group = Key, linetype=Key,colour=serotype,size=serotype))+ 
  geom_line(data = genes_todos, aes(x = genomes, y = genes_to_genomes, group = Key, linetype=Key,colour=serotype,size=serotype))+
  scale_colour_manual(values=c("#fbb03dff","#fd4c50ff","#00a79cff","#00000040"))+
  scale_x_continuous(breaks=seq(1,200, by=1))+
  scale_size_manual(values=c(1.1,1.1,1.1,1.1))+
  ylim(c(1300,2500))+
  xlim(c(1,length(total_CC53)))+
  theme_classic() +
  xlab("No. of genomes") +
  ylab("No. of genes")+ 
  theme_bw(base_size = 16)


ggplot(data = resta_CC53df, aes(x = genomes, y = genes_to_genomes,colour=serotype,size=serotype)) +
  geom_line()+
  geom_line(data = resta_CC63df, aes(x = genomes, y = genes_to_genomes,colour=serotype,size=serotype))+ 
  geom_line(data = resta_CC404df, aes(x = genomes, y = genes_to_genomes,colour=serotype,size=serotype))+ 
  geom_line(data = resta_todosdf, aes(x = genomes, y = genes_to_genomes,colour=serotype,size=serotype))+
  scale_colour_manual(values=c("#fbb03dff","#fd4c50ff","#00a79cff","#00000040"))+
  scale_x_continuous(breaks=seq(1,200, by=1))+
  scale_size_manual(values=c(1.1,1.1,1.1,1.1))+
  ylim(c(0,1000))+
  xlim(c(1,length(total_CC53)))+
  theme_classic() +
  xlab("No. of genomes") +
  ylab("No. of genes")+ 
  theme_bw(base_size = 16)



