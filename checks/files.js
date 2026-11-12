PROOF.checks.data = {
 "version": "1.1.0",
 "files": [
  {
   "path": "certificates/single-marker-7.json",
   "group": "The certificates",
   "bytes": 30354,
   "sha256": "235d1ecad6cb25bfcf9fa0c3150287e6a4d7547a0576f6dcfce8d213a48855a8"
  },
  {
   "path": "certificates/ladder-machine.json",
   "group": "The certificates",
   "bytes": 1138244,
   "sha256": "7f9598209443ddfdf95e96b2e43bdefd1aa77e3ed55f4200f403bf5f8b7f1ffc"
  },
  {
   "path": "certificates/signed-machine.json",
   "group": "The certificates",
   "bytes": 257146,
   "sha256": "628803d23a88646f2ed78e9409beda70582a7881d45d74cd25d5ef947ddc2d53"
  },
  {
   "path": "certificates/manifest.json",
   "group": "The certificates",
   "bytes": 1112,
   "sha256": "644adc1af1b6db57ece36da115ea9be9b2f6ed752c4c8b9e2f3c58672d6a1a20"
  },
  {
   "path": "checker/check_certificate.py",
   "group": "The checker",
   "bytes": 20693,
   "sha256": "e90cc833f2daee7c62a0cecbd4291281814e7a1794a21ce5e0aca8852a51603b"
  },
  {
   "path": "checker/check_crossing_corollary.py",
   "group": "The checker",
   "bytes": 2908,
   "sha256": "0ed248ce2f96a4c274a0319fc3453d464ca87112e6fbcfb508f41b613275d3d3"
  },
  {
   "path": "checker/check_reduction_obligations.py",
   "group": "The checker",
   "bytes": 7617,
   "sha256": "7d2f19ec433f41672bfa391660dbd876e61cc0ac26a7776bde70ad9a1191dfd1"
  },
  {
   "path": "tests/test_certificate_rejection.py",
   "group": "The tests",
   "bytes": 6301,
   "sha256": "5de32b572aa74454497569c8310881da851bab6c3ce96272cc82d2d1a6bf4cbd"
  },
  {
   "path": "tests/test_reduction_obligations.py",
   "group": "The tests",
   "bytes": 1627,
   "sha256": "8e9e2b4036f14466643a8d5ae4e5980c46a1237b428196912abd3a3221fdaba3"
  },
  {
   "path": "scripts/verify.py",
   "group": "The package's own commands",
   "bytes": 3342,
   "sha256": "b14d104f9b1e17d86db16808d37083d6f5efa69e3dcbd54d40b2b41988f1ce89"
  },
  {
   "path": "scripts/check_integrity.py",
   "group": "The package's own commands",
   "bytes": 1280,
   "sha256": "9981012f3ab76a8f93dcde59447fe9d515fcce5fba799f02db0d60dea5a06e2e"
  },
  {
   "path": "VERSION",
   "group": "The package's own commands",
   "bytes": 6,
   "sha256": "1575e1af4a95f12f70b4ee6a6adce8160953d93ea17dc2611b90883ccc3ad3b8"
  },
  {
   "path": "src/inputs/base7-prefix-states.jsonl",
   "group": "The small input files",
   "bytes": 24548,
   "sha256": "f300048c3ea359c8d0766515fd92c9f187fa4e44d48a1f141c177e9e8a8f35bb"
  },
  {
   "path": "src/inputs/base7-cont-states.jsonl",
   "group": "The small input files",
   "bytes": 13453,
   "sha256": "7ac4423bd6cc4f73a2c20df51d9160abf80648839f3710296e7a412e225c7914"
  },
  {
   "path": "src/inputs/ladder-cores.json",
   "group": "The small input files",
   "bytes": 86885,
   "sha256": "fdecbe79ce6e449b1894150c0b243eeb3238e81647278b58bbfe5f8c2d668f60"
  },
  {
   "path": "src/generate_certificate.py",
   "group": "The generator",
   "bytes": 3105,
   "sha256": "8a6e32374d3d5d4bb5ad92e9ce5e4313f47076347e4be49e22a7e3943fece9d4"
  },
  {
   "path": "src/single_marker.py",
   "group": "The generator",
   "bytes": 2867,
   "sha256": "a1559417773232d4d598b490c9125cfc30cd46c7cf62c87d8230788e195a7697"
  },
  {
   "path": "src/marker_machine.py",
   "group": "The generator",
   "bytes": 5602,
   "sha256": "7eb42118f48f5731797d81f8695b311e01a68783db9a7d9a1f399120d82f7cee"
  },
  {
   "path": "src/signed_machine.py",
   "group": "The generator",
   "bytes": 9484,
   "sha256": "3df0ff58a48ed0c2f8463c63e4ab97f00e1b523c1417b9a8b15933fba8273607"
  },
  {
   "path": "src/local_closure.py",
   "group": "The generator",
   "bytes": 745,
   "sha256": "5a20d01a6f4ae11c5b7601ea8b701fb7acd7b6a030a4b30d746dd9b3013b5ac0"
  }
 ],
 "runner": {
  "path": "checks/runner.py",
  "own": true,
  "group": "This page’s own adapter, not part of the release",
  "bytes": 14578,
  "sha256": "328ae1e1ad39d452cb2522b0cbcd1c0cd429ef9293132ceca1a1e095a7d1f55e"
 },
 "python": {
  "pyodide": "314.0.7",
  "bytes": 13531207
 },
 "tests": {
  "count": 14,
  "need_process": [
   "test_missing_file_is_rejected",
   "test_missing_scale_row_is_rejected_by_real_main",
   "test_optimized_python_is_refused"
  ]
 },
 "no_process": "needs a second process",
 "ordinary": {
  "python": "3.9.12",
  "platform": "macOS",
  "reports": {
   "certificate-verification.json": {
    "bytes": 691,
    "sha256": "3084ca5cb08ec00a5947a2661feb1ef12480c7725302248c4fabff69e2a56b2a"
   },
   "crossing-corollary-verification.json": {
    "bytes": 3841,
    "sha256": "6d7dbfc3dfd7d5f6f468ac35746488876cb17242c74d70234a4d2b562cb552ac"
   },
   "direct-base-verification.json": {
    "bytes": 911,
    "sha256": "71a18bd1e49594162acdd65eae36d0093462df9ac1c43fb1fe26dd1a919391f0"
   },
   "reduction-obligations.json": {
    "bytes": 5994,
    "sha256": "951fc97c3ece4052dfb930af57788f921f401009b4b1fb91c292926a12b25020"
   }
  }
 },
 "quotes": {
  "limits": [
   {
    "file": "scripts/verify.py",
    "text": "Finite certificate checks, direct base case, conditional corollary, supplementary reduction premises, and rejection tests. Not a formal proof or human review."
   }
  ],
  "steps": {
   "integrity": {
    "file": "scripts/check_integrity.py",
    "text": "Check the recorded bytes, not the mathematical claims."
   },
   "check_crossing_corollary.py": {
    "file": "checker/check_crossing_corollary.py",
    "text": "This is a conditional corollary of the uniform signed transition proof. It does not prove an upper bound or re-audit that proof."
   },
   "check_reduction_obligations.py": {
    "file": "checker/check_reduction_obligations.py",
    "text": "This script checks additional bounds used in docs/reduction-audit-2026-11-02.md; the universal implications remain prose."
   }
  }
 },
 "alterations": [
  {
   "id": "missing-scale-row",
   "path": "certificates/signed-machine.json",
   "test": "test_missing_scale_row_is_rejected_by_real_main",
   "title": "Take out the last scale transition",
   "what": "The certificate then lists 35 transitions from one scale to the next, where the proof needs all 36.",
   "bytes": 252227,
   "sha256": "e8653881c78c133ed8ecd23c0c4dc0baf65e05b14a77be0f028cff9f95c8254b",
   "ordinary": {
    "integrity": {
     "exit_code": 1,
     "last": "ValueError: Integrity mismatch: certificates/signed-machine.json"
    },
    "check_certificate.py": {
     "exit_code": 1,
     "last": "AssertionError"
    }
   },
   "at": 223350,
   "delete": ",{\"k\":75,\"initial\":[[-1,-2],[[1,2,[]],[-1,1,[]]]],\"inner\":{\"sides\":{\"1\":[106,[]],\"-1\":[1,[]]},\"current\":[1,100],\"word\":[[1,3],[1,2],[1,9],[1,8],[1,7],[1,6],[1,5],[1,4],[1,11],[1,10],[1,17],[1,16],[1,15],[1,14],[1,13],[1,12],[1,19],[1,18],[1,25],[1,24],[1,23],[1,22],[1,21],[1,20],[1,27],[1,26],[1,33],[1,32],[1,31],[1,30],[1,29],[1,28],[1,35],[1,34],[1,41],[1,40],[1,39],[1,38],[1,37],[1,36],[1,43],[1,42],[1,49],[1,48],[1,47],[1,46],[1,45],[1,44],[1,51],[1,50],[1,57],[1,56],[1,55],[1,54],[1,53],[1,52],[1,59],[1,58],[1,65],[1,64],[1,63],[1,62],[1,61],[1,60],[1,67],[1,66],[1,73],[1,72],[1,71],[1,70],[1,69],[1,68],[1,75],[1,74],[1,81],[1,80],[1,79],[1,78],[1,77],[1,76],[1,83],[1,82],[1,89],[1,88],[1,87],[1,86],[1,85],[1,84],[1,91],[1,90],[1,97],[1,96],[1,95],[1,94],[1,93],[1,92],[1,99],[1,98],[1,105],[1,104],[1,103],[1,102],[1,101],[1,100]]},\"first_exit\":{\"sign\":1,\"initial_front\":106,\"initial_state\":[-6,[]],\"prefix\":[],\"cycle\":[[[-6,[]],[1,[1]],0,1],[[1,[1]],[-2,[]],2,0],[[-2,[]],[5,[5]],0,5],[[5,[5]],[4,[4,5]],0,4],[[4,[4,5]],[3,[3,4,5]],0,3],[[3,[3,4,5]],[2,[2,3,4,5]],0,2],[[2,[2,3,4,5]],[1,[1,2,3,4,5]],0,1],[[1,[1,2,3,4,5]],[-6,[]],6,0]],\"modulus\":8,\"residue\":7,\"phase\":3,\"front\":-1,\"state\":[5,[5]],\"entry\":-3,\"prefix_points\":[]},\"core\":{\"k\":75,\"offset\":-3,\"core\":[-100,-99,-98,-97,-96,-95,-94,-93,-92,-91,-90,-89,-88,-87,-86,-85,-84,-83,-82,-81,-80,-79,-78,-77,-76,-75,-74,-73,-72,-71,-70,-69,-68,-67,-66,-65,-64,-63,-62,-61,-60,-59,-58,-57,-56,-55,-54,-53,-52,-51,-50,-49,-48,-47,-46,-45,-44,-43,-42,-41,-40,-39,-38,-37,-36,-35,-34,-33,-32,-31,-30,-29,-28,-27,-26,-25,-24,-23,-22,-21,-20,-19,-18,-17,-16,-15,-14,-13,-12,-11,-10,-9,-8,-7,-6,-5,-4,-3,-2,-1,0]},\"anchor_used\":true,\"ladder_key\":[-3,[-100,-99,-98,-97,-96,-95,-94,-93,-92,-91,-90,-89,-88,-87,-86,-85,-84,-83,-82,-81,-80,-79,-78,-77,-76,-75,-74,-73,-72,-71,-70,-69,-68,-67,-66,-65,-64,-63,-62,-61,-60,-59,-58,-57,-56,-55,-54,-53,-52,-51,-50,-49,-48,-47,-46,-45,-44,-43,-42,-41,-40,-39,-38,-37,-36,-35,-34,-33,-32,-31,-30,-29,-28,-27,-26,-25,-24,-23,-22,-21,-20,-19,-18,-17,-16,-15,-14,-13,-12,-11,-10,-9,-8,-7,-6,-5,-4,-3,-2,-1,0]],\"bottom\":null,\"transfer_keys\":[\"[[1,-2,[]],8,7]\"],\"approach\":{\"initial_front\":2,\"initial_state\":[-1,[]],\"prefix\":[],\"cycle\":[[[-1,[]],[-1,[]],1,0]],\"modulus\":1,\"residue\":0,\"offset\":-3,\"front\":-256,\"state\":[-1,[]],\"prefix_points\":[]},\"outer\":{\"sides\":{\"1\":[2,[4]],\"-1\":[-2,[2,3]]},\"current\":[1,1],\"word\":[[-1,-256],[-1,-255],[-1,-254],[-1,-253],[-1,-252],[-1,-251],[-1,-250],[-1,-249],[-1,-248],[-1,-247],[-1,-246],[-1,-245],[-1,-244],[-1,-243],[-1,-242],[-1,-241],[-1,-240],[-1,-239],[-1,-238],[-1,-237],[-1,-236],[-1,-235],[-1,-234],[-1,-233],[-1,-232],[-1,-231],[-1,-230],[-1,-229],[-1,-228],[-1,-227],[-1,-226],[-1,-225],[-1,-224],[-1,-223],[-1,-222],[-1,-221],[-1,-220],[-1,-219],[-1,-218],[-1,-217],[-1,-216],[-1,-215],[-1,-214],[-1,-213],[-1,-212],[-1,-211],[-1,-210],[-1,-209],[-1,-208],[-1,-207],[-1,-206],[-1,-205],[-1,-204],[-1,-203],[-1,-202],[-1,-201],[-1,-200],[-1,-199],[-1,-198],[-1,-197],[-1,-196],[-1,-195],[-1,-194],[-1,-193],[-1,-192],[-1,-191],[-1,-190],[-1,-189],[-1,-188],[-1,-187],[-1,-186],[-1,-185],[-1,-184],[-1,-183],[-1,-182],[-1,-181],[-1,-180],[-1,-179],[-1,-178],[-1,-177],[-1,-176],[-1,-175],[-1,-174],[-1,-173],[-1,-172],[-1,-171],[-1,-170],[-1,-169],[-1,-168],[-1,-167],[-1,-166],[-1,-165],[-1,-164],[-1,-163],[-1,-162],[-1,-161],[-1,-160],[-1,-159],[-1,-158],[-1,-157],[-1,-156],[-1,-155],[-1,-154],[-1,-153],[-1,-152],[-1,-151],[-1,-150],[-1,-149],[-1,-148],[-1,-147],[-1,-146],[-1,-145],[-1,-144],[-1,-143],[-1,-142],[-1,-141],[-1,-140],[-1,-139],[-1,-138],[-1,-137],[-1,-136],[-1,-135],[-1,-134],[-1,-133],[-1,-132],[-1,-131],[-1,-130],[-1,-129],[-1,-128],[-1,-127],[-1,-126],[-1,-125],[-1,-124],[-1,-123],[-1,-122],[-1,-121],[-1,-120],[-1,-119],[-1,-118],[-1,-117],[-1,-116],[-1,-115],[-1,-114],[-1,-113],[-1,-112],[-1,-111],[-1,-110],[-1,-109],[-1,-108],[-1,-107],[-1,-106],[-1,-105],[-1,-104],[-1,-103],[-1,-102],[-1,-101],[-1,-100],[-1,-99],[-1,-98],[-1,-97],[-1,-96],[-1,-95],[-1,-94],[-1,-93],[-1,-92],[-1,-91],[-1,-90],[-1,-89],[-1,-88],[-1,-87],[-1,-86],[-1,-85],[-1,-84],[-1,-83],[-1,-82],[-1,-81],[-1,-80],[-1,-79],[-1,-78],[-1,-77],[-1,-76],[-1,-75],[-1,-74],[-1,-73],[-1,-72],[-1,-71],[-1,-70],[-1,-69],[-1,-68],[-1,-67],[-1,-66],[-1,-65],[-1,-64],[-1,-63],[-1,-62],[-1,-61],[-1,-60],[-1,-59],[-1,-58],[-1,-57],[-1,-56],[-1,-55],[-1,-54],[-1,-53],[-1,-52],[-1,-51],[-1,-50],[-1,-49],[-1,-48],[-1,-47],[-1,-46],[-1,-45],[-1,-44],[-1,-43],[-1,-42],[-1,-41],[-1,-40],[-1,-39],[-1,-38],[-1,-37],[-1,-36],[-1,-35],[-1,-34],[-1,-33],[-1,-32],[-1,-31],[-1,-30],[-1,-29],[-1,-28],[-1,-27],[-1,-26],[-1,-25],[-1,-24],[-1,-23],[-1,-22],[-1,-21],[-1,-20],[-1,-19],[-1,-18],[-1,-17],[-1,-16],[-1,-15],[-1,-14],[-1,-13],[-1,-12],[-1,-11],[-1,-10],[-1,-9],[-1,-8],[-1,-7],[-1,-6],[-1,-5],[-1,-4],[-1,3],[-1,2],[1,-1],[1,0],[1,1]]},\"output\":[[1,1],[[1,2,[4]],[-1,-2,[2,3]]]]}",
   "insert": ""
  },
  {
   "id": "wrong-greedy-choice",
   "path": "certificates/ladder-machine.json",
   "test": "test_wrong_greedy_choice_is_rejected",
   "title": "Change one recorded choice of the walk",
   "what": "In the first marker certificate one number of the first step of its cycle becomes one larger.",
   "bytes": 1138244,
   "sha256": "b2073aacad88f3074b544a0618e8b9997671e59662d92d0a00de55829c2441aa",
   "ordinary": {
    "integrity": {
     "exit_code": 1,
     "last": "ValueError: Integrity mismatch: certificates/ladder-machine.json"
    },
    "check_certificate.py": {
     "exit_code": 1,
     "last": "AssertionError"
    }
   },
   "at": 164,
   "delete": "0",
   "insert": "1"
  },
  {
   "id": "broken-ladder-closure",
   "path": "certificates/ladder-machine.json",
   "test": "test_broken_ladder_closure_is_rejected",
   "title": "Change the state a ladder ends in",
   "what": "In the first ladder case one number of the last row’s state becomes one larger, so the ladder no longer closes.",
   "bytes": 1138244,
   "sha256": "6652b1dd4981ab702e5a4f2cec62f86ce1381af992e3cdf35c3d6de33048f636",
   "ordinary": {
    "integrity": {
     "exit_code": 1,
     "last": "ValueError: Integrity mismatch: certificates/ladder-machine.json"
    },
    "check_certificate.py": {
     "exit_code": 1,
     "last": "AssertionError"
    }
   },
   "at": 911581,
   "delete": "2",
   "insert": "3"
  },
  {
   "id": "missing-auxiliary-edge",
   "path": "certificates/single-marker-7.json",
   "test": "test_missing_auxiliary_edge_is_rejected",
   "title": "Take out one edge of the single-marker certificate",
   "what": "The last of its listed edges is removed.",
   "bytes": 30345,
   "sha256": "1513d4cb2a99fc24221b7b744c80eec452b42b1a406365e03eeed937b5fcbc3f",
   "ordinary": {
    "integrity": {
     "exit_code": 1,
     "last": "ValueError: Integrity mismatch: certificates/single-marker-7.json"
    },
    "check_certificate.py": {
     "exit_code": 1,
     "last": "AssertionError"
    }
   },
   "at": 27816,
   "delete": ",[92,4,0]",
   "insert": ""
  }
 ],
 "map": {
  "D13": "the scene that defines the checker and the certificates",
  "10.1": "what has been checked, and by what",
  "10.4": "Check it yourself: the scene the window is named after"
 }
};
