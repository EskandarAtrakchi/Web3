/*
ImportantNOTES: 
1. the owner can create a pool 
2. if the owner decided to close a pool the owner will need poolID and proposalID 
3. poolID is shown when a pool is first created but proposalID is not there unless the owner creates a 
DAO voting and if yes more than no then a proposal ID will be generated to cancel the pool by using poolID and proposalID  
 */
function openNav() {
document.getElementById("mySidenav").style.width = "250px";
}

function closeNav() {
document.getElementById("mySidenav").style.width = "0";
}