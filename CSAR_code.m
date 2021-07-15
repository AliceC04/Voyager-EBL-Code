clear all;
close all; %clear all variables and arrays
clf; %clear all figures
addpath('/Users/alice.chemali/Documents/Rays 2021/Raith_GDSII-master'); %from work.
disp('Running program:')
file_name = mfilename

% Defining the properties of the rectangles:
b = 10; % um
h = 100; % um
p = 20; % um
no_rectangles = 11;
base_dose = 50; % uC/cm2
start_dose = 50; % uC/cm2
stop_dose = 150; % uC/cm2
df_start = start_dose/base_dose;
df_stop = stop_dose/base_dose;
df_step = (df_stop - df_start)/no_rectangles;
DF = df_start:df_step:df_stop;

% Defining the end coordinates for a line segment, turned into a rectangle thanks to the path Raith_element type:
u = [0  0];
v = [-h/2  h/2];

% Generating all paths as elements of a Raith_element array:
rec_num = 0;
for i=1:no_rectangles
    u_update = u + i*p;
    rec_num = rec_num+1;
    E(rec_num)=Raith_element('path',0,[u_update;v],b,DF(i));
end

% Making a structure out of the Raith_elements:
S(1)=Raith_structure('rectangles',E);


% Adding membrane frames of corner membranes for reference (layer 1 - not to be printed):
% Defining membrane parameters and using them for creating Raith structures (membrane frames):
w_mem = 250; %um (membrane width).
t_mem = 0; %um (thickness of the membrane edge).
u_mem = [0  w_mem   w_mem   0       0];
v_mem = [0  0       w_mem   w_mem   0];
p_mem = 1000; %um (pitch separating membranes).
df_mem = 2;
E_mem = Raith_element('path',1,[u_mem; v_mem],t_mem,df_mem);
% S(2) = Raith_structure('membrane',E_mem);

% Structure into library:
disp('Saving structures in library:')
L_name = file_name
L = Raith_library(L_name,S);
L.writegds;

% Defining positionlist-specific parameters:
cs = 5.25; %chip size (width) in mm.
wf = 500; %write field (width) in um.
w_mem = 250; %um (membrane width).
mem_num_2D = 16; %total number of membranes.
mem_num_1D = sqrt(mem_num_2D); %1D size of membrane array.

% Defining a positionlist where the objects in L are allocated:
disp('Consulting the .csf file from the following path on the voyager machine:')
P_path = ['U:\mattias\GDSII\Gitter\' L_name '.csf'] % HAS TO MATCH THE VOYAGER FILE CATALOG
P = Raith_positionlist(L,P_path,[wf wf],[cs cs]);
pattern_centering = w_mem/(2000); % mm
disp('Appending structures to the positionlist...') %again, bottom to top, left to right.
for I=1:mem_num_1D %horizontal axis for membrane array --> column #
    for J=1:mem_num_1D %vertical axis for membrane array --> row #
        P.append(S(1).name,[I J+pattern_centering],1,[-wf/2 -wf/2 wf/2 wf/2]); % collocating a set of rectangles per membrane.
%         P.append(S(2).name,[I,J],1,[-wf/2 -wf/2 wf/2 wf/2]); % indicating where the membrane edges are.
    end
end

% Plotting:
disp('Plotting the positionlist ...')
% P.plot;
P.plotedges; %only plots the contours of all structures for faster image processing.

% Writing positionlist to MATLAB directory:
P.writepls;