clear all;
close all;
clf;
addpath('/Users/alice.chemali/Documents/Rays Project/Raith_GDSII-master');
%E=Raith_element('polygon',0,[0 10 10 0;0 0 50 50],1);
DF=1:0.2:3;
for i=1:11
    E(i)=Raith_element('polygon',0,[(10*i+(i-2)*10) (10*i+(i-2)*10+10) (10*i+(i-2)*10+10) (10*i+(i-2)*10);0 0 50 50],DF(i));
end

S=Raith_structure('11-rectangles',E); 
clf;
axis equal;
S.plot;

L=Raith_library('rec',S); 
L.writegds;

P=Raith_positionlist(L,'/Users/alice.chemali/Documents/Rays Project/MATLAB/library.csf',[500 500],[5.25 5.25]);

for b=1:4
    for i=1:4
    P.append('11-rectangles',[b+0.1 i+0.01],1,[-250 -250 250 250]);
    end
end

clf;
P.plot;
P.plotWF;
P.writepls;
