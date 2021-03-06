## Make csvs for sharks in Salaverry and San Jose
# May 29, 2017

library (tidyverse)

gn.trips <- read.csv ("./Data_tables/probable_gillnets.csv")
gn.trips$Fecha.de.zarpe <- as.Date (gn.trips$Fecha.de.zarpe, format = "%Y-%m-%d")
gn.trips$fecha.de.llegada <- as.Date (gn.trips$fecha.de.llegada, format = "%Y-%m-%d")

set.DLL <- read.csv("./Data_tables/set_DLL.csv")
set.DLL$Lance.code <- as.character( (set.DLL$Lance.code))

sharks <- read.csv("./Data_tables/cleaned_sharks.csv") # messed with shark_main already
# sharks$Lance.code <- paste(sharks$trip.code, sharks$lance, sep = "_")
# sharks <- left_join(sharks, set.DLL, by = "Lance.code") %>%
#   rename (Species = species, Trip.code = trip.code) # fix capitals to match other data frames

# all.gn <- filter (trips, !Net.depth.category %in% "Fondo", Sistema %in% c("cortina", "manual", "red", "rayera", "mechanico","mixed nets"), !is.na(trips$panes) | !is.na(trips$pane.1), linea.madre.net.depth != "profundidad", Lugar.de.zarpe != "constante") # use a couple data columns in case. if there's hooks, that's longlines

svry.trip <- filter (gn.trips, Lugar.de.zarpe == "Salaverry", Fecha.de.zarpe >= "2005-01-01")
svry.trip.extra <- filter (gn.trips, Trip.code %in% c(264, 564, 1433))
svry.trip <- rbind (svry.trip, svry.trip.extra) # 289 trips (287 trips...)

write.csv (svry.trip, file = "./Data_tables/svry_trip.csv", row.names = FALSE)

# Make a csv of just the sharks in Salaverry, and save it into the Sharks project
svry.sharks <- filter (sharks, Trip.code %in% svry.trip$Trip.code) # 8615 sharks (9232 sharks...) 9031 sharks??????

write.csv (svry.sharks, file = "../PDsharks/Data_tables/Salaverry_sharks.csv", row.names = FALSE)


sj.trip <- filter (gn.trips, Lugar.de.zarpe == "San Jose" | Lugar.de.zarpe == "Bayovar" | Lugar.de.zarpe == "bayovar")
sj.trip.extra <- filter (gn.trips, Trip.code == 599) # ? this doesn't exist anymore...but it's back now
sj.trip <- rbind (sj.trip, sj.trip.extra) # 94 trips, 181 trips??


sj.sharks <- filter (sharks, Trip.code %in% sj.trip$Trip.code) # 3776 sharks, now 5817 sharks...

write.csv (sj.sharks, file = "../PDsharks/Data_tables/SanJose_sharks.csv", row.names = FALSE)

#####
# Also write csv of svry shark trips

svry.shark.trips <- filter (gn.trips, Trip.code %in% svry.sharks$Trip.code) # (272 trips)
write.csv (svry.shark.trips, file = "../PDsharks/Data_tables/Svry_shark_trips.csv", row.names = FALSE)


### Also shark sets? These are sets that caught sharks, not all sets from trips targeting sharks. It might be worth also looking at trips/sets that targeted sharks but didn't catch them. 
svry.shark.sets <- read_csv ("./Data_tables/cleaned_sets.csv") %>%
  filter (Lance.code %in% svry.sharks$Lance.code) # 1773 sets, now 1769

write.csv (svry.shark.sets, file = "../PDsharks/Data_tables/Svry_shark_sets.csv", row.names = FALSE)
