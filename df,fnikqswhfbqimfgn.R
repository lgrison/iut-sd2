logements_neufs <- read.csv("C:/Users/lgrison/Downloads/dpe-v2-logements-neufs.csv", header = TRUE, dec = ".", sep = ",")
logements_existants <- read.csv("C:/Users/lgrison/Downloads/dpe-v2-logements-existants.csv", header = TRUE, dec = ".", sep = ",")


# Afficher la dimension des deux datasets
print(dim(logements_existants))
print(dim(logements_neufs))

# Ajouter une colonne 'Logement' avec la valeur 'ancien' ou 'neuf' selon le dataset
logements_existants$Logement <- "ancien"
logements_neufs$Logement <- "neuf"

# Fusionner les deux dataframes en conservant uniquement les colonnes communes
colonnes_communes <- intersect(names(logements_existants), names(logements_neufs))
data_combined <- rbind(
  logements_existants[, colonnes_communes],
  logements_neufs[, colonnes_communes]
)

# Créer une colonne avec uniquement l'année de la date de réception du DPE
data_combined$Annee_reception_DPE <- as.numeric(substr(data_combined$Date_réception_DPE,1,4))
  
# Créer une colonne pour vérifier si Coût_total_5_usages correspond bien à la somme des coûts individuels
data_combined$Verif_Cout_Total <- (data_combined$Coût_chauffage + 
                                     data_combined$Coût_éclairage + 
                                     data_combined$Coût_ECS + 
                                     data_combined$Coût_refroidissement + 
                                     data_combined$Coût_auxiliaires) == data_combined$Coût_total_5_usages

# Créer une colonne 'Coût_chauffage_en_%' indiquant la part du coût du chauffage dans le coût total 5 usages
data_combined$Cout_chauffage_en_pourcentage <- (data_combined$Coût_chauffage / data_combined$Coût_total_5_usages) * 100

# Afficher le dataframe final
print(data_combined)
