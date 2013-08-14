iv 
vv 播放量
cv 有效果播放量
adshow

------------------------------- html -------------------------------------------------
<head>
    <title>shen100的播放器</title>
<head>

flashvars.vid = "_o6KtpZ_0IfLaK1_RHcnfA..";

//改变播放器的尺寸大小
function setSize(width, height)  
{   
    document.getElementById("${application}").width = width;   
    document.getElementById("${application}").height = height;   
} 
			
//开灯
function turnon()
{
    document.body.style.backgroundColor='#ffffff';
}
		
//关灯		
function turnoff()
{
    document.body.style.backgroundColor='#101010';
}
