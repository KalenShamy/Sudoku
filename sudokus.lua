local sudokus = {
	Easy = {"00gaf00000db00e000fi0000000b000a0000dh000000000000gi000000hi0ae0f0d00bg0e00b0a0i0 || hegafbdciadbciehfgficgdhaebbgfiadehcdhiecfgbacaehbgidfgbdfhicaeifadecbghechbgafid" ,"c00g0he00ia000000b0b00000000f0000d0000a0000f00000e000000i00eb0d000hf00ga00gd00i00 || cdfgbheaiiahedfgcbgbeiacfdhefcbhadigbgacidhfehidfegabcfciagebhddebhficgaahgdcbief" ,"00000i0d00000b0e000h0df000ac00hegd000000000gh000000ie0fe00000b00ga0ief000000ab0c0 || abfegihdcicdabhefgghedfcbiacfihegdabeabidfcghhdgbcaieffecghdabibgaciefhddihfabgce" ,"c00be000ag0i000bcf00000g0000000da000h00f0b0d0000hg000000e000000ad000f00hb0f00hi0g || cfhbeidgageiahdbcfdabcfgehiegcidahfbhiafcbgdefbdhgeaicihegbcfadadgeifcbhbcfdahieg" ,"0ca0g0hd000000i00a0dicb0000d000i00e0a0f00ei00g00h0db00000b00000000a00000e0000000f || bcaegfhdifegdhicbahdicbafgedhcfibaegabfgceihdgiehadbfcigdbfceahcfhaegdibeabidhgcf" ,"g00hbc00i0cb00fd00ia0d00000000b0afg000g000000000ei0000000000ia000f000e0b00e0000df || gfdhbcaeiecbiafdhgiahdgebfccdibhafgebegcfdhiafhaeigcbddgcfebiahaifgdhecbhbeacigdf" ,"gf0ec000b00c00d00gb0d000ae0fh00e00000000bgh000a0d00fb0000hg00i0i0000aegd0000f0000 || gfaecidhbhecbadifgbidhgfaecfhbaecgdiedifbghcacagdihfbeachgdebifibfchaegddgeifbcah" ,"00cbef00000000ha0b000a0dg000b0i00000000000d0000dg0000ci0000gh0a0000000d0dcgfh0e00 || gacbefihdfdicghaebbheaidgcfebaidcfghcgfhabdiehidgfebaciebdcghfaafhebicdgdcgfhaebi" ,"e000f0gd0000dg0a0c0000a000000000h00ece0g000a0f00000h0b000f000ia00da00ec0a000edfbh || ehabfcgdiibfdgeahcdgchaibefgabidhcfecehgbfiadfdiecahgbbcefhgdiahfdaibecgaigcedfbh" ,"0b0000afc000i000gbg0dbf00ei00e00ig0f0000e00ah00000dc00h0000a0000g0c0b0000e0d000b0 || ebigdhafcfchiaedgbgadbfcheibheacigdfidcfegbahafghbdciehibegafcddgfcibehaceadhfibg" ,"b00a0h00ee0i0g0hd000fe00a0g0000b00c000eghi00a000d00f0h0000fc0e0000h00g0ff00i00b0c || bdgaihcfeeaicgfhdbhcfedbaigdghfbaecicfeghidbaaibdcefghghabfciedibchedgaffediagbhc" ,"00eih000000f00gc0bai00d00fe00b0000c0i0000agd00c0eg000ie000b00h0000h00b00000d000g0 || cbeihfdaghdfaegcibaigcdbhfegabfidechiehbcagdffcdeghabiefagbcihddgchfibeabhidaefgc" ,"0000fg000d000bc0e000gi00fa00000h000cad000i000000dc00if000ha0e0000fc0dh000a000bi00 || bhaefgcdidfiabcgehecgidhfabfiebhadgcadcfgibhehgbdceaifibdhafecggefcidhbacahgebifd" ,"c00b00g0h0b00d0000000000e0ib0000id0ggfhe0000c00000c0fa0h0df0a0e0000000000000e00hd || cafbiegdhebihdgcafhdgacfebibcafhideggfheadbicdiegbchfaihcdfbageaedighfcbfgbceaihd" ,"b0d0ic0he0a00e00000f0h0000c000f0ge0ied0c00ga000000a00hf00000000g0000000f0ha00b000 || bgdaicfhehacbefigdifehgdabcabhfdgeciedfchigabcigebadfhfeigchbdagcbdaehifdhaifbceg" ,"b0e0f00iagh00ce0db0i00ah00c0000000fh0b0000000e00a0000ia0000f0g00di0bga00c0b0e000f || bcegfdhiaghaicefdbdifbahgeciadegbcfhhbcfdieagefgahcdbiaehcifbgdfdihbgacecgbdeaihf" ,"iab000000d000000gf00000e0i000i000gc0bc00000d0e0000d00ic0f00ih0ga000gc00b0ed0b0if0 || iabgcfehddheiabcgffgchdebiahdibfagcebcaeigfdhefgchdabicbfdeihagaihfgcdebgedabhifc" ,"fgihd0e00000gi0b0000cf0a0d00f000d00000b0000e00e00000i00a00000h0e0db000000bhc00000 || fgihdbecaadegicbfhbhcfeagdiifaecdhbgdcbihgaefhegabfcidcafdgeihbeidbahfgcgbhcfidae" ,"0f0ac0h00a00be00d00bh0d00i0000eag0f000c00000e000h00dgbb0000000ie0i000000h0d000g00 || dfeacihbgaigbehfdccbhgdfeiaidbeagcfhghcdfbiaefeahicdgbbgfchdaeiecifgabhdhadibegcf" ,"0ce00000bi00cbgh00d0hfa0g0c000000000hef0d00000000e0000fi00000gd0000i00f0000d0aeb0 || gceihdfabifacbghdedbhfaegicbdchgfieahefadibcgagibecdhffibechagdeadgibcfhchgdfaebi" ,"0ia0g0db00000cd0he00000000000d0fc00gf000h00ed0eh0000000000000ah000cb00g00b0he000f || hiafgedbcgfbacdihecdebihgfabadefchigfgcihbaediehdagfcbecigdfbahdhfcbaegiabgheicdf" ,"g000i00he000000fad000f00c000000adib0a0f00cd00000000000e0gdc00000i00h0a0b0h00e0000 || gfdciabheicebghfadhbafdecigcgheadibfaefibcdghbdihfgecaeagdcbhfidicghfaebfhbaeigdc" ,"000i00b0000gc00h00000e000d00g00fec0i0ae000g00000000000d00h0geice0c0a000000h000dba || hdfigabceiegcdbhafacbehfidgbgdafechicaebihgfdfhigcdaebdfahbgeicebcdaifghgihfecdba" ,"0000b0000b0dca0g0000c0f0e00ib0g000a0g000e0fd0da0000b0h0000000ecf0b00000000a0g0h00 || efgdbhicabidcaeghfahcifgebdibfghdcaegchaebfdidaeficbghhgibdfaecfebhcadigcdaegihfb" ,"d0h0f0000gci00ef00e0acg0000c00g00a00000b00hf00e0000000a0e00g000b0000ceh0000eh00dg || dbhafigecgcihdefabefacgbdihcdfgehabiiagbcdhfehebiafcgdahedbgicfbgdficehaficehabdg"},
	Medium = {'h00d0000b0e0a00hc000bh00eg00g00b00a0b000f0000i0d0g000000cb0000000g000000d00000b00 || hcidegafbgefaibhcdadbhcfegicghibdfaebaecfhidgifdegacbhfhcbdegiaebgfaidhcdiaghcbef','00f00000cdia000fb0000e0000000c0000dhg00c0000000d0a000f00000b0c0i00000g00f0hd00b00 || egfibadhcdiahgcfbechbedfaigbacgfeidhgfichdeabhedbaicgfadgfebhciibeachgfdfchdigbea','000d00e0b0e0af00id0h000i000000e0000f00efba00c0000dc000000i0000ad00g0eb00c000000d0 || aifdghecbgecafbhidbhdceifaghcaeigdbfidefbaghcfbghdcaeiefbihdcgadaigcebfhcghbafide','0bg00000i000i0ec000000c0f00ia000g000h000a00f0f00eh000a0000i0000000000gd00fcg000ah || cbghdfaeiadfigechbeihbcafgdiadfbghcehcedaibfgfgbehcdiaghacidebfbeiafhgdcdfcgebiah','c0i0e000d0e0d000c0f000000bh0000b0000000c00f0000c00a0i0000bah00000000i00b0ag00000e || chigebafdaebdhfgcifgdaicebhgfaibehdcibhcdgfeaedchfabigdiebahcgfhcfegidabbagfcdihe','000b00a000000h000g000a0000d00bfc000h0g00daf00c0e00b00ab00c0000000f000bd0i000000ge || fidbegahcabcihdefggehafcibddabfcigehhgiedafcbcfehgbdiabdgciehafecfgahbdiihadbfcge','ad00000i00000db00000000a0g000b0000000a0000eb0fi00ehda000000ga00000i0000000c0ad0e0 || adfghcbiehgiedbfcabcefiahgddebacfihgcahdgiebffigbehdacehdcbgafigbaifecdhifchadgeb','000000ie00000e00gd00000000b00000000000dgc000hc0g0f0b00b00ag0hf0g00d0c00eh00000000 || fgcbdhieaabhiefcgddeicagfhbeabhidgcfifdgcbeahchgefabdibdeagihfcgifdhcabehcafbedig','b0000h00f0hc0000dg000cf0i000cf0a000000bf00000d000e000ce0d00ba000fh0000000000d0000 || biedghcaffhcabiedgadgcfeibhhcfiadgebgebfhcdiadaibegfhcegdhcbaficfheiabgdibagdfhce','00000e00c000h000b00deb00000c0ai0000h00000d000i00gc00000ic00000gdb00g00000e0000f0i || bagfdeihcfcihagebdhdebicgfacfaiebdghegbahdcifihdgcfaebaicefhbdgdbfcgihaegehdbafci','00000c000000ifa0e00d000000000e000a0000f000ch000g0hefi0i0000h00f0hcg0i00000bca0000 || efidgcbahbghifadeccdahebifghiefcdagbdbfaigcheacgbhefidiadebhgcffhcgdiebagebcafhdi','d0h000000000000e00000h0gi0d00f0000aec0d000fg00g0a0000000c0a0d00b00g0c000a0ebd0gc0 || dbhieacfgicgdfbehafeahcgibdhifcgdbaecadebhfgiegbaifhdcghcfaedibbdighcaefafebdigch','000g0000abc0000e0if00000b000000b0000e0h00f0c00b000e000ig000d00000fca00000a00g0000 || dieghbcfabcgfdaehifhaiecbgdafcdbgiehedhaifgcbgbihceadfigbefdhachefcaidbgcadbghfie','b00000aci00000f000a00000b00fdh00000a00b0d0if00i0000e000f0a0i00d0hg0000000000fe000 || bgfdehacihcibafdegaedicgbhffdheibcgaeabgdcifhgicfhaedbcfeagihbdihgcbdfaedbahfegic','00000d0000i0a000c0000000had00e0000baf00000c00d00000e0h000bd000g00h0ea0000af000b00 || ahgfcdiebeidabhgcfcfbegihadhceifgdbafbadhecgidgicabefhiecbdfahgbdhgeaficgafhicbde','00g0ai0d0b00000000e000d000g0000000e0000f0d00c000e00b0d0ea0000i000fi0000eh0000f0a0 || fcgbaiedhbdhgfeicaeaihdcfbgdfbacgheiihefbdagcagceihbfdgeadhbcifcbfigadhehidcefgab','i0000f0c00c0b000fh0d0000g00000hb00000e000i000f00a0d0000000fha00h000cbi00d0ig00000 || ihgedfbcaacebigdfhbdfchageigadhbceifcebfgihadfihaedcbgegcifhadbhfadcbigedbigaefhc','00gb0000h0e0d000000i00gh00b000000a0i0de0i0000g0000b000f00000dc00000c00000a00f0h00 || dfgbeicahhebdacgifciafghedbbhfcdeagiadegifbhcgciahbfedfghibadceebdhcgifaiacefdhbg','0000000d0000000a00geb0c000i0c0e000000b0dfceh000fh000g00000d0g00h0i00000000d0i00c0 || fhaibecdgdicfhgaebgebacdhfiachegidbfibgdfcehaedfhabigccfebdagihhgicefbadbadgihfce','0000b00cf0000f0b0i0d000a0000000000g0i00ahc00000000i0haa00b00e000h000000cb0e0000fg || eaihbgdcfcghdfebaifdbicagehhcafdbigeiegahcfdbdbfgeichaafcbgheidghdeifabcbiecadhfg','00000ch0000000e00000ebgd00000bcifg0dd00000a00f0c0000000d0000000000g00i0000gefb00c || ibdfachgegfaihecdbchebgdfaihabcifgeddeihbgacffgcdeabihbdhaciefgecfgdhibaaigefbdhc','000f000a0000b0c00000000000000e0i00d000hc000000ica0000000a00ic00d00g0fe0b00000b00i || cebfdhiagiafbgcdehhgdieabcfabehigfdcfdhcbegiagicafdhbebfaehicgddcigafehbehgdcbafi','a0gif0b0000bgc00he0c0000f00000e0000d000h00gc00000000000bhc00000caf00e0000g0bh00f0 || aegifhbdcfibgcdahehcdaebfgibfceighadedihbagcfghafdceibibhcafdegcafdgeibhdgebhicfa','00a0i00g00i0ebc00a00000000de0b00000000000h0f00g00f00ib0e00000d0gb0a00000000c00bef || bhafidegcdigebcfhafcehgaibdefbgcidahidcbahgfeaghdfecibcefihbadggbdaefhcihaicdgbef','0e0h00c00000d000000a00b0hegi000000f000h0gc0de0g0000a000000000a000000ed00d0000a00b || geihafcbdhbcdegfiafadcbihegideahbgfcafhigcbdecgbefdahiecgbdhiafbiafcedghdhfgiaecb',},
	Hard = {'0000d0ig000a0gi000e0000000ca0g0i0000000b0000h00ch000000000000c000h0000dagf000000e || hcbadeigffdacgiehbegifbhdacahgeicbfddefbagcihibchfdaegbaedhfgcicihgebfdagfdicahbe','0000bf000c00000000000h0a0000a00ib0d00bi0d00h00c0000a000e0f0c00g00d0h000c00000i0f0 || idgebfhcachaigdfebefbhcaigdhafcibgdegbiadechfdcegfhabibehfacdigfidbhgeacagcdeibfh','d0000000i0cbd0e0f000g0a00000i000000ga0e0di000b0c0000000ei0cg00h000000g00000bi0000 || dahfbcegiicbdgehfaefgiahcbdhifcebdagagehdifcbbdcgfaihefeiacgbdhcbaehdgifghdbifaec','0e000ga00f0giac00000000000000ah00cg00000c0000000gbi00000h00b00db000id00000e00hg0b || cebdhgafifdgiacbehhaibefdcgibahdecgfghdfcaibeefcgbihdaachegbfidbgfaidehcdiecfhgab','0i0000cb0eb000f00gfc000a000000g0000hb000i0f00c00000ad0000000000000cfb000d0000ib00 || hiaedgcbfebdicfhagfcgbhaeidaefgbdichbdhaicfgecgifehadbihbdaegfcgaecfbdhidfchgibea','fh00000000i0d0000f000a0c00d0000000g0000g0hid0he00i0000g0000i0f00b00000000d000bg0a || fhdibeacgaicdhgebfegbafchiddcieafbghbfagchidehegbidfacgaehdicfbcbhfgadeiidfcebgha','00000000g0gc00000f0dfg0000ed00b00000c00ige0000000c0ia000g000h00i00e0000000b00f00a || eihdfcabgbgcheadifadfgbichedfibahegcchaigebfdgbefcdiahfcgadbheiiadehgfcbhebcifgda','i0db0ga000fhid00c000000000f0g0000b0ie00g000f00hf00000d00b000000000000d00g0000b0i0 || icdbfgaehafhidegcbbeghcaidfdgacefbhiebighdcfachfabiegdhibdgcfaefaceihdbggdefabhic','00000ad00d000000ac0c000i00h0000000000h0000cf000000fhgah00f00a0d00a0heb000ec0g0000 || gfhbcadiedibefhgacacegdifbhcafhigedbehgdabcfiibdcefhgahgifbcaedfdaihebcgbecagdihf','00geicd0000i000e0f000da000c000id000e0bc0000000g00b0i00000g00f0000h00000g0000c000b || afgeicdbhcdihgbeafehbdafgichafidgbceibcafehgddgecbhifabcaghdfeifihbeacdggedfciahb','be000000000000i0eff00e0ad000h00a000g00f0bd00c000fh0000g000d0fhb000000000000000gc0 || beadfhcgihdgbciaeffciegadbhihdcaebfgegfibdhacabcfhgeidgieadcfhbcfhgebidadabhifgce','0000f000d00h000000ae00000g000f0000000b000c000000d000ieh00c0000b0000eg0h0dce0hfg00 || gicafehbdbfhgcdieaaedhbicgfidfeahbcgebgficadhchadgbfiehgicdaefbfabiegdhcdcebhfgai','00000b000000h00f0ig000da00e00000000a000e0f0c0ed00hi00000hf0e0000000000000bg0000ad || ihegfbadcbadhecfgigcfidabhehfbdcgieaagiebfdchedcahigfbdihfaecbgceabgdhiffbgcihead','00000e0b0dec0000i000f000g0c0g00c0a0000000g00d00e0ah0f00d000c000c0i0e00a0f00000000 || giachedbfdecfgbhiahbfidagecbgdecfahiafhbigecdicedahbfgedbafcighchigedfabfaghbicde','0e000g000gi000000000h0000f00hdi000ec0f0e0h0i0000a00fd0cb00fa0000000000000000ci0h0 || feacighbdgibfhdecadchbaeifgbhdigfaecafcedhgibigeabcfdhcbihfadgehdfgebcaieagdcibhf','c000gh0b0000edb000000f000i00000b00gc00b0000f000000e000e0000f0a0a00000d00f0ch00b0g || ceaighfbdigfedbchabhdfacgiedfeabihgcgabchdefihcigfeadbebgdcfiahaihbegdcffdchiabeg','g0h00f00ai00e000f00fd000h0000ad0g000000ce0i00e000000g000g000000bd0000ghf00000000d || gehicfbdaiabehdcfgcfdbgahiehiadbgfecdgfcehiabebcfaidghfcghdeabibdeaicghfahigfbecd','000b0h00a0g00fi00d0d00a0e0000chgf000000000b0h0000000a000000d00f000g0a0i00b0000g00 || fcebdhigaagbefichdhdicagefbbachgfdeigfdaiebcheihdcbfagchgiedabfdefgbahicibafhcgde','e00h00d000g000d0a0d000ag00hc000b00i000000i00c00ae00000000000ed0g0h00000f00e0000b0 || eachfbdgihgicedfabdfbiagcehchdfbagiebegdhiafcfiaegcbhdacfbihedggbhadeicfidegcfhba','dh0c0f0000g00000d0ea000000f000000fh0i0000000e00000000ba00fe0b00f000hd0a00000abd00 || dhbcifgeacgfabehdieaihdgcbfbcaegifhdifdbchagegehdfaicbadgfecbihfbcihdeaghiegabdfc','i0h0000fgg0000i00000000c00i0bfc0g0ed0c000f0ih0000be00000ia000bc00000h000c000000g0 || idhbeacfggacfdiehbbfeghcdaihbfcigaedecgdafbihdiahbegcffeiagdhbcagbichfdechdefbiga','0000d0h00i0c0h00f0000a0000caf0gb00d000g00000b000d0f00e0000000ad000h000c00b00c000g || gafedchbiiecbhgdfabhdafigecafigbecdhedgcahfibhcbdifagecghfebiaddiehgabcffbaicdehg','000b0d000h000000e0000eai000e000f0g0a00dci000b0c00000000f0000e000000000i0be0f00000 || igebhdafchbagcfdeicdfeaihbgeihdfbgcagadciefhbfcbhgaideafcibhegddhgaecbifbeifdgcah','d00c0b0ea00000000b00g00dif000000i0000000c0000ch0a0e0i0000d0000c0b000g000if0000000 || dihcfbgeafeaighdcbbcgeadifhedbghicafgaibcfehdchfadebighgediafbcabcfeghdiifdhbcage','00c0gb000000c0eg00h000f00000c0d000g000af0gb00f0e000a000a000d0b0e00a0c0000000b00i0 || dechgbiafaficdeghbhbgifacedbchdaifgeidafegbchfgebchadigafeidhbceibahcdfgchdgbfeia',}
}

local module = {

}

function module:getPuzzle(difficulty)
	if not sudokus[difficulty] then
		return "000000000000000000000000000000000000000000000000000000000000000000000000000000000 || 000000000000000000000000000000000000000000000000000000000000000000000000000000000"
	else
		return sudokus[difficulty][love.math.random(#sudokus[difficulty])]
	end
end

return module