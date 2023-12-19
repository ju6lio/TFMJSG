library(ggplot2)

setwd("/home/julio/Documents/WGSNM/FigurasS3roary")

conserved_todos = colMeans(read.table("number_of_conserved_genes.Rtab"))
total_todos  = colMeans(read.table("number_of_genes_in_pan_genome.Rtab"))
resta_todos = total_todos-conserved_todos

genes_todos = data.frame(genes_to_genomes = c(conserved_todos ,total_todos),
                         genomes = c(c(1:length(conserved_todos)),c(1:length(conserved_todos ))),
                         Key = c(rep("Conserved genes",length(conserved_todos)), rep("Total genes",length(total_todos))))
genes_todos$serotype<-"Serotype todos"

resta_todosdf = data.frame(genes_to_genomes= resta_todos, genomes= c(1:length(resta_todos)), Key= rep("Resta genes", length(resta_todos)))
resta_todosdf$serotype <- "Serotype todos"

#CC180

conserved_CC180 = colMeans(read.table("number_of_conserved_genes_CC180.Rtab"))
total_CC180 = colMeans(read.table("number_of_genes_in_pan_genome_CC180.Rtab"))
resta_CC180 = total_CC180-conserved_CC180

genes_CC180 = data.frame( genes_to_genomes = c(conserved_CC180,total_CC180),
                         genomes = c(c(1:length(conserved_CC180)),c(1:length(conserved_CC180))),
                         Key = c(rep("Conserved genes",length(conserved_CC180)), rep("Total genes",length(total_CC180))))

genes_CC180$serotype<-"Serotype CC180"

resta_CC180df = data.frame(genes_to_genomes= resta_CC180, genomes= c(1:length(resta_CC180)), Key= rep("Resta genes", length(resta_CC180)))
resta_CC180df$serotype <- "Serotype CC180"

#CC260

conserved_CC260 = colMeans(read.table("number_of_conserved_genes_CC260.Rtab"))
total_CC260 = colMeans(read.table("number_of_genes_in_pan_genome_CC260.Rtab"))
resta_CC260 = total_CC260-conserved_CC260

genes_CC260 = data.frame( genes_to_genomes = c(conserved_CC260,total_CC260),
                         genomes = c(c(1:length(conserved_CC260)),c(1:length(conserved_CC260))),
                         Key = c(rep("Conserved genes",length(conserved_CC260)), rep("Total genes",length(total_CC260))))

genes_CC260$serotype<-"Serotype CC260"

resta_CC260df = data.frame(genes_to_genomes= resta_CC260, genomes= c(1:length(resta_CC260)), Key= rep("Resta genes", length(resta_CC260)))
resta_CC260df$serotype <- "Serotype CC260"


genes<-rbind(genes_todos,genes_CC180,genes_CC260)


ggplot(data = genes_CC180, aes(x = genomes, y = genes_to_genomes, group = Key, linetype=Key,colour=serotype,size=serotype)) +
  geom_line()+
  geom_line(data = genes_CC260, aes(x = genomes, y = genes_to_genomes, group = Key, linetype=Key,colour=serotype,size=serotype))+ 
  geom_line(data = genes_todos, aes(x = genomes, y = genes_to_genomes, group = Key, linetype=Key,colour=serotype,size=serotype))+
  scale_colour_manual(values=c("#fbb03dff","#fd4c50ff","#00000040"))+
  scale_x_continuous(breaks=seq(1,200, by=1))+
  scale_size_manual(values=c(1.1,1.1,1.1))+
  ylim(c(1300,2500))+
  xlim(c(1,length(total_CC180)))+
  theme_classic() +
  xlab("No. of genomes") +
  ylab("No. of genes")+ 
  theme_bw(base_size = 16)


ggplot(data = resta_CC180df, aes(x = genomes, y = genes_to_genomes,colour=serotype,size=serotype)) +
  geom_line()+
  geom_line(data = resta_CC260df, aes(x = genomes, y = genes_to_genomes,colour=serotype,size=serotype))+ 
  geom_line(data = resta_todosdf, aes(x = genomes, y = genes_to_genomes,colour=serotype,size=serotype))+
  scale_colour_manual(values=c("#fbb03dff","#fd4c50ff","#00000040"))+
  scale_x_continuous(breaks=seq(1,200, by=1))+
  scale_size_manual(values=c(1.1,1.1,1.1))+
  ylim(c(0,1000))+
  xlim(c(1,length(total_CC180)))+
  theme_classic() +
  xlab("No. of genomes") +
  ylab("No. of genes")+ 
  theme_bw(base_size = 16)



