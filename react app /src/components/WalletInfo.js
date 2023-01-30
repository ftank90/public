import { useWeb3React } from '@web3-react/core';

const WalletInfo = () => {
  const { active, chainId, account, error } = useWeb3React();
  return (
    <div className="wallet-info">
      <p>Taloc</p> <img src="favicon.ico" width="70" 
     height="70" class="logo"></img> 
      {active && (
        <div>
          <p>Account: {account}</p>
      
        </div>
      )}
      {error && <p className="text-error">error: {error.message}</p>}
    </div>
  );
};

export default WalletInfo;
