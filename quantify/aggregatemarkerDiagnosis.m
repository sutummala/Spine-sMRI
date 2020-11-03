function aggregatemarkerDiagnosis(qc, Age, Tex, type, multi, cv)

m1 = [Age.age1 Age.age2 Age.age3 Age.age4 Age.age5];
m2 = [Tex.msi1 Tex.msi2 Tex.msi3 Tex.msi4 Tex.msi5];
m3 = [Tex.ent1 Tex.ent2 Tex.ent3 Tex.ent4 Tex.ent5];
m4 = [Tex.con1 Tex.con2 Tex.con3 Tex.con4 Tex.con5];
m5 = [Tex.cor1 Tex.cor2 Tex.cor3 Tex.cor4 Tex.cor5];
m6 = [Tex.ene1 Tex.ene2 Tex.ene3 Tex.ene4 Tex.ene5];
m7 = [Tex.hom1 Tex.hom2 Tex.hom3 Tex.hom4 Tex.hom5];

ls = [ones(length(Tex.msi1),1)' 2*ones(length(Tex.msi2),1)' 3*ones(length(Tex.msi3),1)' 4*ones(length(Tex.msi4),1)' 5*ones(length(Tex.msi5),1)'];

% Rescale to have standard deviation of one
%sm1 = m1./std(m1);
sm2 = m2./std(m2);
sm3 = m3./std(m3);
sm4 = m4./std(m4);
sm5 = m5./std(m5);
sm6 = m6./std(m6);
sm1 = m7./std(m7);

% All classes
d1(:,1) = sm1(ls == 1); d2(:,1) = sm1(ls == 2); d3(:,1) = sm1(ls == 3); d4(:,1) = sm1(ls == 4); d5(:,1) = sm1(ls == 5);
d1(:,2) = sm2(ls == 1); d2(:,2) = sm2(ls == 2); d3(:,2) = sm2(ls == 3); d4(:,2) = sm2(ls == 4); d5(:,2) = sm2(ls == 5);
d1(:,3) = sm3(ls == 1); d2(:,3) = sm3(ls == 2); d3(:,3) = sm3(ls == 3); d4(:,3) = sm3(ls == 4); d5(:,3) = sm3(ls == 5);  
d1(:,4) = sm4(ls == 1); d2(:,4) = sm4(ls == 2); d3(:,4) = sm4(ls == 3); d4(:,4) = sm4(ls == 4); d5(:,4) = sm4(ls == 5);  
d1(:,5) = sm5(ls == 1); d2(:,5) = sm5(ls == 2); d3(:,5) = sm5(ls == 3); d4(:,5) = sm5(ls == 4); d5(:,5) = sm5(ls == 5);
d1(:,6) = sm6(ls == 1); d2(:,6) = sm6(ls == 2); d3(:,6) = sm6(ls == 3); d4(:,6) = sm6(ls == 4); d5(:,6) = sm6(ls == 5);  
%d1(:,7) = sm7(ls == 1); d2(:,7) = sm7(ls == 2); d3(:,7) = sm7(ls == 3); d4(:,7) = sm7(ls == 4); d5(:,7) = sm7(ls == 5);  

if ~cv % Don't do cross validation
    if multi % Multi-class discrimination
        W = multiLDA(d1, d2, d3, d4, d5);
        aggm = W(1)*sm1 + W(2)*sm2 + W(3)*sm3 + W(4)*sm4 + W(5)*sm5 + W(6)*sm6;
        aggm = aggm./max(aggm);
        separateDDD(aggm(ls == 1), aggm(ls == 2), 'D1', 'D2', 'Combomarker', 0);
        separateDDD(aggm(ls == 2), aggm(ls == 3), 'D2', 'D3', 'Combomarker', 0);
        separateDDD(aggm(ls == 3), aggm(ls == 4), 'D3', 'D4', 'Combomarker', 0);
        separateDDD(aggm(ls == 4), aggm(ls == 5), 'D4', 'D5', 'Combomarker', 0);
    else
        W = LDA([d1; d2], [d3; d4; d5]);
        aggm = W(1)*sm1 + W(2)*sm2 + W(3)*sm3 + W(4)*sm4 + W(5)*sm5 + W(6)*sm6;
        aggm = aggm./max(aggm);
        separateDDD([aggm(ls == 1) aggm(ls == 2)], [aggm(ls == 3) aggm(ls == 4) aggm(ls == 5)], 'D1D2', 'D3D4D5', 'Combomarker', 1);
    end    
else
    % LOOCV starts here
    c = cvpartition(ls, 'leaveout');
    num  = length(ls);
    trainAuc = zeros(num,1);
    testls = trainAuc;
    trainweights = zeros(num, size([d1; d2],2));

    % Resize healthy and ddd to matct to the data size
    [row col] = size([d1; d2]);
    healthy(1:row, 1:col) = [d1; d2];
    healthy(row+1:num, 1:col) = 0;
    ddd1(1:num, 1:col) = 0;
    ddd1(row+1:num, 1:col) = [d3; d4; d5];
    ddd = ddd1;

	% Training
    for i = 1:num
        templs = ls;
    	templs(c.training(i) == 0) = 0;
        testls(c.test(i) == 1) = 1;
    	fprintf('\nLOOCV %d/%d', i, num);
            switch type
                case 1
                    W = LDA(healthy(templs ==1 | templs == 2,:), ddd(templs >=3,:));
                case 2
                    lskda = [ones(length(healthy(templs ==1 | templs == 2,:)),1); zeros(length(ddd(templs >=3,:)),1)];
                    options.Kernel = 0;
                    W = KDA(options, lskda, [healthy(templs ==1 | templs == 2,:); ddd(templs >=3,:)]);
                otherwise
                    error('Wrong slection of discrimant analysis method');
            end
        % Agrregate marker is the weighted sum of individual markers
        aggm = W(1)*sm1 + W(2)*sm2 + W(3)*sm3 + W(4)*sm4 + W(5)*sm5 + W(6)*sm6 + W(7)*sm7;

        % Train AUC for Combo marker
        AUC = separateDDD([aggm(templs == 1) aggm(templs == 2)], [aggm(templs == 3) aggm(templs == 4) aggm(templs == 5)], 'D1D2', 'D3D4D5', 'TrainCombo', 0);

        trainAuc(i) = AUC(1);
        trainweights(i,:) = W';
        clear AUC W
    end
    
    % Testing
    fprintf('\nTesting AUC is being calculated');
    testW = median(trainweights);

    aggm = testW(1)*sm1 + testW(2)*sm2 + testW(3)*sm3 + testW(4)*sm4 + testW(5)*sm5 + testW(6)*sm6 + testW(7)*sm7;
    aggm = aggm./max(aggm);

    ls(testls == 0) = 0;

    % Test AUC for Combo Marker
    separateDDD([aggm(ls == 1) aggm(ls == 2)], [aggm(ls == 3) aggm(ls == 4) aggm(ls == 5)], 'D1D2', 'D3D4D5', 'TrainCombo', 0);
end


