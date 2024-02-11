/*
ImportantNOTES: 
1. the owner can create a pool 
2. if the owner decided to close a pool the owner will need poolID and proposalID 
3. poolID is shown when a pool is first created but proposalID is not there unless the owner creates a 
DAO voting and if yes more than no then a proposal ID will be generated to cancel the pool by using poolID and proposalID  
===========================================
the vote function takes in three arguments: the proposal ID, the user’s vote (yes or no), and the ID of the NFT they own. The function checks if the caller of the function is the owner of the NFT with the specified ID by calling the ownerOf function. If the caller is not the owner of the NFT, the function reverts with an error message. This check is performed to ensure that only NFT owners can vote on proposals.
===========================================
The vote function also uses the NFT ID to determine the voting power of the user. The function retrieves the USDT value of the NFT with the specified ID from the tokenIdToUSDT mapping and adds this value to either the powerYes or powerNo variable of the specified proposal, depending on whether the user voted yes or no. This means that users who own NFTs with a higher USDT value have more voting power than users who own NFTs with a lower USDT value.
===========================================
 */
function openNav() {
document.getElementById("mySidenav").style.width = "250px";
}

function closeNav() {
document.getElementById("mySidenav").style.width = "0";
}


/*
cancelPool
FundFactory
Vote
*/