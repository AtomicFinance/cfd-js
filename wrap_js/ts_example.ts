import * as cfdjs from '../index.js';

let supportFunctions: cfdjs.GetSupportedFunctionResponse;
{
  console.log('===== Supported Function =====');
  supportFunctions = cfdjs.GetSupportedFunction();
  console.log('*** Response ***\n', supportFunctions, '\n');
}

const NET_TYPE = 'testnet';
{
  console.log('===== CreateKeyPair =====');
  const reqJson: cfdjs.CreateKeyPairRequest = {
    'wif': true,
    'network': NET_TYPE,
    'isCompressed': true,
  };
  console.log('*** Request ***\n', reqJson);
  const result: cfdjs.CreateKeyPairResponse =
    cfdjs.CreateKeyPair(reqJson);
  console.log('\n*** Response ***\n', result, '\n');
}

/* eslint-disable max-len */
const CONTRACT_CONDS = {
  fundAmt: 5000000000, // fix fund amount (unit:satoshi), which is unconcerned fee
  feeAmt: 8000, // fix fee amount (unit:satoshi) each transaction
  payAddrAlice: 'tb1qmtjru45n7v8rklpan2vfzms7gex23d780lxkl2', // payment address for alice (your party)
  payAddrBob: 'tb1qj52arfpmwxyjwddvjhjy45nkl725h583es0mef', // payment address for bob (couter party)
  chgAddrAlice: 'tb1q6vugzhd50r3yxgejxym0yzylkpkh2qqcvjuqp4', // change address for alice (your party)
  chgAddrBob: 'tb1qy7c7fqkgags3g6j0r8naj6c8fydcaz766d0skr', // change address for bob (couter party)
};
/* eslint-enable max-len */
console.log('\n===== CONTRACT_CONDS =====\n', CONTRACT_CONDS, '\n');

// CreateMultisig
let createMultisigResult: cfdjs.CreateMultisigResponse;
{
  console.log('\n===== CreateMultisig =====');
  const reqJson: cfdjs.CreateMultisigRequest = {
    nrequired: 2,
    keys: [
      '0205ffcdde75f262d66ada3dd877c7471f8f8ee9ee24d917c3e18d01cee458bafe',
      '02be61f4350b4ae7544f99649a917f48ba16cf48c983ac1599774958d88ad17ec5',
    ],
    network: NET_TYPE,
    hashType: 'p2wsh',
    isElements: false,
  };
  console.log('*** Request ***\n', reqJson);
  createMultisigResult = cfdjs.CreateMultisig(reqJson);
  console.log('\n*** Response ***\n', createMultisigResult, '\n');
}
