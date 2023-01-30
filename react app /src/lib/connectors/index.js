import { InjectedConnector } from '@web3-react/injected-connector';


const supportChainIdList = [1, 3, 4, 5, 42, 137, 80001, 11155111];

export const injected = new InjectedConnector({
  supportedChainIds: supportChainIdList,
});


export const connectorList = {
  MetaMask: injected,
};

export default connectorList;
