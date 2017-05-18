oracle('CaseStudy', result([],[],[])).
oracle('DiscussionArtifact',                    % missing Plenary in week 2
       result([],[card_in_slot('206', 'C2-ABA-CSS-TEAM')],[])).
oracle('DiscussionAssignment',         % missing No Technology or Forum in week 3
       result([],[card_in_slot('301', 'C3-ABA-CSS-TEC2'),
                  card_in_slot('310', 'C3-ABA-CSS-TEC2')],[])).
oracle('DiscussionReport',                      % wrong card in C3-ABA-CSS-TEC1
       result(['C3-ABA-CSS-TEC1'],[],[])).
oracle('EtCetera', % wrong cards in C1-ABA-TEC1, C2-ABA-TEAM, C2-ABA-TEC1
       result(['C1-ABA-CSS-TEC1', 'C2-ABA-CSS-TEAM', 'C2-ABA-CSS-TEC1'],[],[])).
oracle('Jigsaw', result([],[],[])).
oracle('PeerReview', result([],[],[])).
oracle('PyramidList', result([],[],[])).
oracle('PyramidPS', result([],[],[])).
oracle('RolePlay', result([],[],[])).

