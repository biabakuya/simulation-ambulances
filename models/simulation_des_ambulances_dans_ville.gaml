/**
* Name: simulation_des_ambulances_dans_ville
* Based on the internal empty template. 
* Author: BYAOMBE MWINDULWA DIEUDONNE, BIABA KUYA JIRINCE, NTOUMBA NGONGO CHRISTINE
* Tags: 
*/


model simulation_des_ambulances_dans_ville

/* Insert your model definition here */

global {
// Chemin des fichiers shapefile
	file ville_shapefile <- file("C:/Users/ibrahim/Videos/Simulation_ambulances/projet/includes/ville.shp");
	file habitation_shapefile <- file("C:/Users/ibrahim/Videos/Simulation_ambulances/projet/includes/maison.shp");
	file hospital_shapefile <- file("C:/Users/ibrahim/Videos/Simulation_ambulances/projet/includes/hopitaux_v.shp");
	file road_shapefile <- file("C:/Users/ibrahim/Videos/Simulation_ambulances/projet/includes/roads.shp");
	file control_center_shapefile <- file("C:/Users/ibrahim/Videos/Simulation_ambulances/projet/includes/centre.shp");
	image_file ambulance_image <- image_file("C:/Users/ibrahim/Videos/Simulation_ambulances/projet/includes/ambulance_1.png");

	// Définition de l'enveloppe de la simulation
	geometry shape <- envelope(habitation_shapefile);
	geometry free_space;
	graph the_graph;

	// Nombre d'ambulances et patients transportés
	int nb_ambulances <- 5;
	int patients_transported <- 0; // Compteur de patients transportés
	int max_patients <- 10; // Nombre maximum de patients à transporter pour terminer la simulation

	// Variables pour les statistiques
	float total_transport_time <- 0.0;
	int total_transports <- 0;
	float total_distance_traveled <- 0.0;
	float total_waiting_time <- 0.0;
	int total_patients <- 0;
	float simulation_time <- 0.0;

	// Paramètres pour ajuster la taille des objets
	float habitation_size <- 0.5 parameter: "Taille des habitations" category: "Taille" min: 0.10 max: 1.0;
	float hospital_size <- 50.0 parameter: "Taille des hôpitaux" category: "Taille" min: 1.0 max: 5.0;
	float road_size <- 1.5 parameter: "Taille des routes" category: "Taille" min: 0.5 max: 1.0;
	float control_center_size <- 50.0 parameter: "Taille du centre de contrôle" category: "Taille" min: 5.0 max: 10.0;
	float ambulance_size <- 100.0 parameter: "Taille des ambulances" category: "Taille" min: 1.0 max: 5.0;

	init {
	// Chargement du shapefile de la ville
		create ville from: ville_shapefile {
			shape <- geometry;
		}

		free_space <- copy(shape);

		// Chargement des Shapefiles et création des entités correspondantes
		create habitation from: habitation_shapefile {
			shape <- shape buffer habitation_size;
		}

		create hospital from: hospital_shapefile {
			shape <- shape buffer hospital_size;
			color <- #blue;
		}

		create road from: road_shapefile {
			shape <- shape buffer road_size;
			the_graph <- as_edge_graph(road);
		}

		create control_center from: control_center_shapefile {
			shape <- shape buffer control_center_size;
		}

		create ambulance number: nb_ambulances {
			location <- any_location_in(free_space);
			target_loc <- nil; // Initialisation de target_loc
			hospital_loc <- location; // Initialisation de hospital_loc à l'emplacement de l'ambulance
			patient_loc <- nil; // Initialisation de patient_loc
		}

	}

}

// Définition de l'espèce ville
species ville {

	aspect default {
		draw shape color: #grey;
	}

}

// Définition de l'espèce habitation
species habitation {
	float height <- rnd(10 #m, 20 #m);

	aspect default {
		draw shape color: #green depth: height;
	}

}

// Définition de l'espèce hôpital
species hospital {
	float height <- rnd(10 #m, 20 #m);

	aspect default {
		draw shape color: #blue depth: height;
	}

}

// Définition de l'espèce route
species road {
	geometry display_shape <- shape + 2;

	aspect default {
		draw display_shape color: #yellow;
	}

}

// Définition de l'espèce centre de contrôle
species control_center {
	float height <- rnd(10 #m, 20 #m);

	aspect default {
		draw shape color: #orange depth: 3;
	}

}

// Définition de l'espèce ambulance avec la compétence de mouvement
species ambulance skills: [moving] {
	float speed <- 1.0 + rnd(500) / 1000;
	point target_loc;
	point hospital_loc;
	point patient_loc;
	bool has_patient <- false;
	float size <- 20.0;
	float transport_start_time <- 0.0; // Temps de début de transport
	float distance_traveled <- 0.0; // Distance parcourue par cette ambulance
	aspect default {
		draw image(ambulance_image) size: size color: (has_patient ? #red : #white);
	}

	reflex receive_order {
		if (location distance_to hospital_loc < 2 and not has_patient) {
			patient_loc <- any_location_in(free_space);
			target_loc <- patient_loc;
			write "Ambulance reçoit l'ordre de récupérer un patient à " + patient_loc;
		}

	}

	reflex move {
		if (target_loc != nil) {
			point old_location <- copy(location);
			do goto target: target_loc on: the_graph;
			if not (self overlaps free_space) {
				location <- (location closest_points_with free_space)[1];
			}

			distance_traveled <- distance_traveled + (location distance_to old_location);
			if (location distance_to target_loc < 2) {
				if (has_patient) {
					write "Ambulance arrive à l'hôpital avec le patient.";
					has_patient <- false;
					target_loc <- nil;
					patients_transported <- patients_transported + 1;
					total_transport_time <- total_transport_time + (time - transport_start_time);
					total_transports <- total_transports + 1;
				} else {
					write "Ambulance récupère le patient à " + location;
					has_patient <- true;
					target_loc <- hospital_loc;
					transport_start_time <- time;
				}

			}

		}

	}

	reflex update_statistics {
		if (has_patient and target_loc = patient_loc) {
			total_patients <- total_patients + 1;
			total_waiting_time <- total_waiting_time + (time - transport_start_time);
		}

		total_distance_traveled <- total_distance_traveled + distance_traveled;
	}

}

// Définition de l'expérience de simulation GUI
experiment simulation_des_ambulances_dans_ville  type: gui {
	parameter "Number of ambulances" var: nb_ambulances min: 1 max: 10000;
	output {
		display map_3D type: opengl {
			species ville;
			species control_center;
			species hospital;
			species habitation transparency: 0.3;
			species road;
			species ambulance;
		}

		display information_Simulation refresh: every(2 #cycles) type: 2d {
			chart "Total Patients Transported" type: series {
				data "Patients Transported" value: patients_transported color: #red;
			}

			chart "temps moyen de transport" type: series {
				data "Average Transport Time" value: (total_transports > 0 ? (total_transport_time / total_transports) : 0.0) color: #blue;
			}

		}

		display "Distance Totale parcourue" refresh: every(2 #cycles) type: 2d {
			chart "Total Distance Traveled" type: series {
				data "Total Distance Traveled" value: total_distance_traveled color: #yellow;
			}

			chart "taux d'occupation des ambulances" type: series {
				data "Ambulance Occupancy Rate" value: (simulation_time > 0 ? (total_transport_time / simulation_time) : 0.0) color: #green;
			}

		}

		display "Patient Waiting Time Distribution" refresh: every(2 #cycles) type: 2d {
			chart "Patient Waiting Time Distribution" type: histogram {
				data "0-5 minutes" value: (total_waiting_time <= 5) color: #lightblue;
				data "5-10 minutes" value: (total_waiting_time > 5 and total_waiting_time <= 10) color: #cyan;
				data "10-15 minutes" value: (total_waiting_time > 10 and total_waiting_time <= 15) color: "blue";
				data "15+ minutes" value: (total_waiting_time > 15) color: #darkblue;
			}

			chart "Ambulance Activity Breakdown" type: pie {
				data "Transporting Patients" value: (patients_transported / nb_ambulances) color: #orange;
				data "Idle" value: (1 - (patients_transported / nb_ambulances)) color: #gray;
			}

		}

	}

}