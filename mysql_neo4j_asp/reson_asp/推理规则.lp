%辅助规则
equal_to_or_stricter_than(Term_name1,Term_name2):- term(Term_name1),term(Term_name2), Term_name1=Term_name2. 
equal_to_or_stricter_than(Term_name1,Term_name2):- term(Term_name1),term(Term_name2), term_relation(Term_name1,Term_name2,"is a"). 
equal_to_or_stricter_than(Term_name1,Term_name2):- term(Term_name1),term(Term_name2), term_relation(Term_name1,Term_name2,"synonym").
equal_to_or_stricter_than(Term_name1,Term_name2):- term(Term_name1),term(Term_name2),Term_name2=null. 

less_than_or_equal_to(Value1,Value2):- Value2=null,value(Value1),value(Value2).
less_than_or_equal_to(Value1,Value2):- Value1<= Value2,value(Value1),value(Value2). 

greater_than_or_equal_to(Value1,Value2):- Value2=null,value(Value1),value(Value2).
greater_than_or_equal_to(Value1,Value2):- Value1>= Value2,value(Value1),value(Value2). 

start(P,MRI_id,Start):- mr_observation(P,MRI_id,Name,Part,Degree,Trend,State,Start,Duration). 
start(P,MRI_id,Start):- mr_disease_history(P,MRI_id,Name,Disease_name,Degree,Start,Duration).
start(P,MRI_id,Start):- mr_contact_history(P,MRI_id,Name,Disease_name,Population_name,Degree,Start,Duration).
start(P,MRI_id,Start):- mr_event(P,MRI_id,Name,Manner,Result,Start,Duration,Agent_id,Object_id).

%要素节点匹配规则
%临床所见症状匹配
match(P, MRI_id,Local_factor_id):- factor(DiseaseDiagnose_id, Local_factor_id, Factor_id),
						factor_observation(Factor_id, Name1, Part1, Degree1, Trend1, State1, Duration_min, Duration_max), 
		         		mr_observation(P, MRI_id, Name2, Part2, Degree2, Trend2, State2, Start, Duration),  
		         		equal_to_or_stricter_than(Name2, Name1), 
		        		equal_to_or_stricter_than (Degree2, Degree1),
		        		equal_to_or_stricter_than(Trend2, Trend1), 
		         		equal_to_or_stricter_than(State2,State1),
		         		less_than_or_equal_to(Duration, Duration_max),
		         		greater_than_or_equal_to (Duration, Duration_min).


%检查结果匹配
match(P, MRI_id,Local_factor_id):- factor(DiseaseDiagnose_id, Local_factor_id, Factor_id),
						factor_inspectionConclusion(Factor_id, Name1, Conclusion1, Part1, Degree1,Trend1, State1), 
		         		mr_inspection_conclusion(P, MRI_id, Name2,Conclusion2, Part2, Degree2, Trend2, State2),  
		         		equal_to_or_stricter_than(Name2, Name1), 
		        		equal_to_or_stricter_than (Degree2, Degree1),
		        		equal_to_or_stricter_than(Trend2, Trend1), 
						equal_to_or_stricter_than(State2,State1),
		         		equal_to_or_stricter_than(Conclusion2,Conclusion1).
		         		
%检查数据匹配
match(P, MRI_id,Local_factor_id):- factor(DiseaseDiagnose_id, Local_factor_id, Factor_id),
						factor_inspection_data(Factor_id, Name1,Value_min, Value_max,Unit1,State1), 
		         		mr_inspection_data(P, MRI_id, Name2, Value, Unit2, State2),  
		         		equal_to_or_stricter_than(Name2, Name1),
		        		equal_to_or_stricter_than(Unit2, Unit1), 
		         		equal_to_or_stricter_than(State2,State1),
		         		less_than_or_equal_to(Value, Value_max),
		         		greater_than_or_equal_to (Value, Value_min).

		         		
%历史疾病匹配
match(P,MRI_id, Local_factor_id):- factor(DiseaseDiagnose_id, Local_factor_id, Factor_id),
						factor_disease_histroy(Factor_id, Name1, Disease_name1, Degree1, Duration_min, Duration_max), 
		         		mr_disease_histroy(P, MRI_id, Name2, Disease_name2, Degree2, Start, Duration),  
		         		equal_to_or_stricter_than(Name2, Name1), 
						equal_to_or_stricter_than(Disease_name2, Disease_name1),
		        		equal_to_or_stricter_than (Degree2, Degree1),
		         		less_than_or_equal_to(Duration, Duration_max),
		         		greater_than_or_equal_to (Duration, Duration_min).
		         		
%接触史匹配
match(P,MRI_id, Local_factor_id):- factor(DiseaseDiagnose_id, Local_factor_id, Factor_id),
						factor_contact_histroy(Factor_id, Name1, Disease_name1, Population_name1, Degree1, Duration_min, Duration_max), 
		         		mr_contact_histroy(P, MRI_id, Name2, Disease_name2, Population_name2, Degree2, Start, Duration),  
		         		equal_to_or_stricter_than(Name2, Name1), 
						equal_to_or_stricter_than(Disease_name2, Disease_name1),
						equal_to_or_stricter_than(Population_name2, Population_name1),
		        		equal_to_or_stricter_than (Degree2, Degree1),
		         		less_than_or_equal_to(Duration, Duration_max),
		         		greater_than_or_equal_to (Duration, Duration_min).
		         		
%匹配复杂要素节点——event类型
match(P, MRI_id,Local_factor_id):- factor(DiseaseDiagnose_id, Local_factor_id, Factor_id), 
			factor_event(Factor_id, Name1, Manner1, Result1, Duration_min, Duration_max), 
			mr_event(P, MRI_id, Name2, Manner2, Result2, Start, Duration, Agent_id, Object_id),  
			equal_to_or_stricter_than(Name2, Name1), 
			equal_to_or_stricter_than(Manner2, Manner1),  
			equal_to_or_stricter_than(Result2, Result1), 
			patient(P),less_than_or_equal_to(Duration, Duration_max),  
			greater_than_or_equal_to(Duration, Duration_min),
			edge_agent(Factor_id, V_id1), 
			edge_object(Factor_id, V_id1), match(P, Agent_id, V_id1), 
			match(P, Object_id, V_id2).

%process类型
-match(P,Local_factor_id):- factor(DiseaseDiagnose_id, Local_factor_id, Factor_id),
					factor_process(Factor_id,Name),
					edge_contains(Factor_id,V_id),patient(P),not match(P,V_id).
match(P,Local_factor_id):- factor(DiseaseDiagnose_id, Local_factor_id, Factor_id),
					factor_process(Factor_id,Name),patient(P),not -match(P,Factor_id).

match(P, Local_factor_id):- match(P, MRI_id, Local_factor_id).


%逻辑节点匹配规则
-match(P,Logic_id):- logic_and(Logic_id),edge_organizes(Logic_id, V_id),patient(P),not match(P, V_id).
match(P,Logic_id):- logic_and(Logic_id),patient(P),not -match(P,Logic_id).
match(P,Logic_id):- logic_or(Logic_id),edge_organizes(Logic_id,V_id),patient(P),match(P,V_id).
match(P,Logic_id):- logic_item(Logic_id),edge_organizes(Logic_id,V_id),patient(P),match(P,V_id).
match(P,DiseaseDiagnose_id):- disease_diagnose(DiseaseDiagnose_id,Disease_name,Disease_icd10,Guideline_text),
			  edge_contains(DiseaseDiagnose_id,Logic_id),match(P,Logic_id),patient(P).
match(P,Logic_id):- logic_sequence(Logic_id,Time_min,Time_max),edge_early(Logic_id,V_id1),
                    edge_late(Logic_id,V_id2),match(P, MRI_id1, V_id1), match(P, MRI_id2, V_id2),
                    start(P,MRI_id1,Start1),start(P,MRI_id2,Start2),Start1>=Start2,
                    less_than_or_equal_to(Start1-Start2,Time_max),
                    greater_than_or_equal_to(Start1-Start2,Time_min).

match(P,DiseaseDiagnose_id):- disease_diagnose(DiseaseDiagnose_id,Disease_name,Disease_icd10,Guideline_text),
                            edge_contains(DiseaseDiagnose_id,Logic_id),
                            match(P,Logic_id),patient(P).
conclude(P,DiseaseDiagnose_id,Disease_name):- match(P,DiseaseDiagnose_id),
                                            disease_diagnose(DiseaseDiagnose_id,Disease_name,Disease_icd10,Guideline_text).
-conclude(P,DiseaseDiagnose_id,Disease_name):- not conclude(P,DiseaseDiagnose_id,Disease_name),
											patient(P),
											disease_diagnose(DiseaseDiagnose_id,Disease_name,Disease_icd10,Guideline_text).

%关系推理
term_relation(A,C,"is a"):- term_relation(A,B,"is a"),term_relation(B,C,"is a"),term(A),term(B),term(C).



%#show match/2.
%#show match/3.
#show conclude/3.
#show -conclude/3.