import React, { Component } from 'react';
import { ethers } from "ethers";


class Metamask extends Component {
  constructor(props) {
    super(props);
    this.state = {
    };
  }

  async connectToMetamask() {
    const provider = new ethers.providers.Web3Provider(window.ethereum)
    const accounts = await provider.send("eth_requestAccounts", []);
    const balance = await provider.getBalance(accounts[0]);
    const balanceInEther = ethers.utils.formatEther(balance);
    this.setState({ selectedAddress: accounts[0], balance: balanceInEther })
  }
  async fetch() {
    const provider = new ethers.providers.JsonRpcProvider();

    // You can also use an ENS name for the contract address
    const daiAddress = "HTTP://127.0.0.1:7545";
    const signer = provider.getSigner()

    // The ERC-20 Contract ABI, which is a common contract interface
    // for tokens (this is the Human-Readable ABI format)
    const daiAbi = [
      // Some details about the token
      "function name() view returns (string)",
      "function symbol() view returns (string)",

      // Get the account balance
      "function balanceOf(address) view returns (uint)",

      // Send some of your tokens to someone else
      "function transfer(address to, uint amount)",

      // An event triggered whenever anyone transfers to someone else
      "event Transfer(address indexed from, address indexed to, uint amount)"
    ];

    // The Contract object
    const daiContract = new ethers.Contract(daiAddress, daiAbi, provider);

    let myAddress = await signer.getAddress()
    // '0x8ba1f109551bD432803012645Ac136ddd64DBA72'

    // Filter for all token transfers from me
    let filterFrom = daiContract.filters.Transfer(myAddress, null);
    
    console.log(filterFrom)
  }
  renderMetamask() {
    if (!this.state.selectedAddress) {
      return (
        <button onClick={() => this.connectToMetamask()}>Connect to Metamask</button>
      )
    } else {
      return (
        <div>
          <p>Welcome {this.state.selectedAddress}</p>
          <p>Your ETH Balance is: {this.state.balance}</p>
          <button onClick={() => this.fetch()}>test</button>
        </div>
      );
    }
  }


  render() {
    return(
        <div>
        {this.renderMetamask()}
      </div>
    )
  }
}

export default Metamask;