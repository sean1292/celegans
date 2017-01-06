function [eleg] = readElegModel(filename,all_mets,all_bigg)

% [eleg] = readElegModel(filename,all_mets,all_bigg)
% reads the icel model and converts it in the necessary format

% INPUT:
% filename: iCEL1273_1.xml, provided the file is in working directory
% all_mets: import coloumn A of "All Metabolites (repeats too)" tab of
% "E:\Dropbox\Sean-Chintan\chintan\Metabolite List.xlsx"
% all_bigg: import coloumn D of "All Metabolites (repeats too)" tab in
% "E:\Dropbox\Sean-Chintan\chintan\Metabolite List.xlsx"

% OUTPUT:
% eleg: Kaleta model in COBRA format

% COMMENTS: KEGG ids still need to be arranged

eleg = readCbModel(filename);
eleg.mets = strrep(eleg.mets,'_c[Cytosol]','[c]');
eleg.mets = strrep(eleg.mets,'_e[Cytosol]','[e]');
eleg.mets = strrep(eleg.mets,'_m[Cytosol]','[m]');
eleg.mets = strrep(eleg.mets,'_n[Cytosol]','[n]');
eleg.mets = strrep(eleg.mets,'_c[Extraorganism]','[c]');
eleg.mets = strrep(eleg.mets,'_e[Extraorganism]','[e]');
eleg.mets = strrep(eleg.mets,'_m[Extraorganism]','[m]');
eleg.mets = strrep(eleg.mets,'_n[Extraorganism]','[n]');
eleg.mets = strrep(eleg.mets,'_c[Mitochondrion]','[c]');
eleg.mets = strrep(eleg.mets,'_e[Mitochondrion]','[e]');
eleg.mets = strrep(eleg.mets,'_m[Mitochondrion]','[m]');
eleg.mets = strrep(eleg.mets,'_n[Mitochondrion]','[n]');
eleg.mets = strrep(eleg.mets,'_c[Nucleus]','[c]');
eleg.mets = strrep(eleg.mets,'_e[Nucleus]','[e]');
eleg.mets = strrep(eleg.mets,'_m[Nucleus]','[m]');
eleg.mets = strrep(eleg.mets,'_n[Nucleus]','[n]');
eleg.mets = strrep(eleg.mets,'_i[Cytosol]','_i[c]');

all_mets = strrep(all_mets,'[c]','');
all_mets = strrep(all_mets,'[e]','');
all_mets = strrep(all_mets,'[m]','');
all_mets = strrep(all_mets,'[n]','');
all_bigg = strrep(all_bigg,'[c]','');
all_bigg = strrep(all_bigg,'[e]','');
all_bigg = strrep(all_bigg,'[m]','');
all_bigg = strrep(all_bigg,'[n]','');

mets = eleg.mets;
compartments = {'c';'e';'m';'n'};
acc = 0;
newmets = [];
for i=1:length(compartments)
    all_mets_ = strcat(all_mets,'[',compartments{i,1},']');
    fprintf('Finding all [%s] metabolites..',compartments{i,1});
    [A,ia,ib] = intersect(all_mets_,mets);
    fprintf('\t%d\n',length(ia));
    acc = acc + length(ia);
    for j=1:length(ia)
        comp = regexp(mets(ib(j)),'[','split');
        comp = strrep(comp{1,1}{1,2},']','');
        newmets{ib(j),1} = strcat(all_bigg{ia(j),1},'[',comp,']');
    end
end
if ~isempty(newmets)
    eleg.oldmets = eleg.mets; eleg.mets = newmets;
    fprintf('%d metabolites out of %d accounted for.\n',acc,length(eleg.oldmets));
end