// personal assistant agent 

/* Task 2 Start of your solution */

/* Inference Rules */

// Inference rule for infering the belief requires_brightening if the target illuminance is higher than the current illuminance
requires_brightening :- target_illuminance(Target) & current_illuminance(Current) & ((Target - Current) <= 100 | (Target - Current) >= Current -100).

// Inference rule for waking up user based on the best option
best_option("al") :- al_ranking(rankValue) & rankValue < ((nl_ranking(rankValue) & rankValue) | (vib_ranking(rankValue) & rankValue)).
best_option("nl") :- nl_ranking(rankValue) & rankValue < ((al_ranking(rankValue) & rankValue) | (vib_ranking(rankValue) & rankValue)).
best_option("vib") :- vib_ranking(rankValue) & rankValue < ((al_ranking(rankValue) & rankValue) | (nl_ranking(rankValue) & rankValue)).

/* Initial beliefs */

//Ranking for artificial light
al_ranking(2).

//Ranking for natural light
nl_ranking(1).

//Ranking for vibration
vib_ranking(0).

// The agent has the initial goal to start
!start.

@start_plan
+!start : true <-
    .print("Started the programm");
    !upcoming_event("now").

@awake_upcoming_plan
+upcoming_event(State) : upcoming_event("now") & owner_state("awake") <-
    .print("Enjoy your event").

@wake_up_user_with_al_plan
+upcoming_event(State) : upcoming_event("now") & owner_state("asleep") & best_option("al") <-
    .print("Starting wake-up routine with artificial light");
    turnOnLights;
    +owner_state(State) & State == "awake".
    
@wake_up_user_with_nl_plan
+upcoming_event(State) : upcoming_event("now") & owner_state("asleep") & best_option("nl") <-
    .print("Starting wake-up routine with natural light");
    raiseBlinds;
    +owner_state(State) & State == "awake".

@wake_up_user_with_vib_plan
+upcoming_event(State) : upcoming_event("now") & owner_state("asleep") & best_option("vib") <-
    .print("Starting wake-up routine with vibration");
    setVibrationsMode;
    +owner_state(State) & State == "awake".

@errorhandling
+upcoming_event(State) : true <-
    .print(errorhandling).

@show_best_option_plan
+best_option(Option) : true <-
    .print("Best option is ", Option).
    

@show_blinds_state_plan
+blinds(State) : true <-
    .print("Blinds are ", State).

@show_lights_state_plan
+lights(State) : true <-
    .print("Lights are ", State).

@show_mattress_state_plan
+mattress(State) : true <-
    .print("Mattress is ", State).

@show_owner_state_plan
+owner_state(State) : true <-
    .print("Owner is ", State).


/* Task 2 End of your solution */

/* Import behavior of agents that work in CArtAgO environments */
{ include("$jacamoJar/templates/common-cartago.asl") }