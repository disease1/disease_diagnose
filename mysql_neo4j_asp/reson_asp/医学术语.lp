
patient("病人1").

%病人1
term(null).
term("呼吸音粗").
term("血常规").
term("右胸").
term("左胸").
term("胸部").
term("双肺").
term("双下肺").
term("未见明显异常").
term("无明显诱因发热").
term("咳黄痰").
term("胸持续性酸胀痛").
term("乏力").
term("体温").
term("℃").
term("T").
term("次/分").
term("P").
term("R").
term("BP").
term("mmHg").
term("脉搏").
term("呼吸").
term("血压").
term("颅脑外伤史").
term("颅脑外伤").

value("10y").
value("39").
value("39.4").
value("120").
value("23").
value("124/72").

%社区获得性肺炎
term("咳嗽"). 
term("呼吸道症状"). 
term("脓性痰"). 
term("白细胞数量"). 
term("胸部X线检查"). 
term("片状浸润性阴影"). 
term("肺部"). 
term("加重"). 
term("新出现的"). 
term("咳痰").
term("原有的").
term("肺实变").
term("发热").
term("湿性啰音").
term("斑片状浸润性阴影").
term("间歇性改变").
term("/L").


value("1w").
value(null).
value("10*10^9").
value("4*10^9").
value("38").

%推理关系

term_relation("T","体温","is a").
term_relation("P","脉搏","is a").
term_relation("R","呼吸","is a").
term_relation("BP","血压","is a").
term_relation("右胸","胸部","is a").
term_relation("左胸","胸部","is a").
term_relation("双肺","肺部","is a").
term_relation("双下肺","肺部","is a").
term_relation("咳黄痰","咳痰","is a").
term_relation("无明显诱因发热","发热","is a").
term_relation("胸持续性酸胀痛","胸痛","is a").
term_relation("咳痰","脓性痰","is a").
term_relation("咳嗽","呼吸道症状","is a").
term_relation("咳痰","呼吸道症状","is a").
term_relation("新出现的","原有的","is a").