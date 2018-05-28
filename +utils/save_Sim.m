function  save_Sim(solLi,tSt, ySt, tT, yT, const, path)
%SAVE_SIM Save simulation and paramater values
    
save(path,'solLi','tSt','ySt','tT', 'yT','const');

end

