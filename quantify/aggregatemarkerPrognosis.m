function aggregatemarkerPrognosis(qc, prog, nonprog)

lab = [ones(length(prog),1)' zeros(length(nonprog),1)'];

m1 = [prog(:,1)' nonprog(:,1)'];
m2 = [prog(:,2)' nonprog(:,2)'];
m3 = [prog(:,3)' nonprog(:,3)'];
m4 = [prog(:,4)' nonprog(:,4)'];
m5 = [prog(:,5)' nonprog(:,5)'];
m6 = [prog(:,6)' nonprog(:,6)'];
m7 = [prog(:,7)' nonprog(:,7)'];

% Scaled with standard deviation
%sm1 = m1./std(m1);
sm2 = m2./std(m2);
sm3 = m3./std(m3);
sm4 = m4./std(m4);
sm5 = m5./std(m5);
sm6 = m6./std(m6);
sm1 = m7./std(m7);

% progressors
prog(:,1) = sm1(lab == 1);
prog(:,2) = sm2(lab == 1);
prog(:,3) = sm3(lab == 1);
prog(:,4) = sm4(lab == 1);
prog(:,5) = sm5(lab == 1);
prog(:,6) = sm6(lab == 1);
%prog(:,7) = sm7(lab == 1);

% nonprogressors
nonprog(:,1) = sm1(lab == 0);
nonprog(:,2) = sm2(lab == 0);
nonprog(:,3) = sm3(lab == 0);
nonprog(:,4) = sm4(lab == 0);
nonprog(:,5) = sm5(lab == 0);
nonprog(:,6) = sm6(lab == 0);
%nonprog(:,7) = sm7(lab == 0);

W = LDA(prog, nonprog);

aggm = W(1)*sm1 + W(2)*sm2 + W(3)*sm3 + W(4)*sm4 + W(5)*sm5 + W(6)*sm6;

separateDDD(aggm(lab == 1), aggm(lab == 0), 'Progressors', 'Nonprogressors', 'ComboMarker', 1);