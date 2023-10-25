#!/bin/bash

cp $1 /opt/ccf_sgx/bin

echo "$CERTD" > /opt/ccf_sgx/bin/cert
echo "$KEYD" > /opt/ccf_sgx/bin/key

cd /opt/ccf_sgx/bin
echo "Submitting the JS app."
content=$(ccf_cose_sign1 --ccf-gov-msg-type proposal --ccf-gov-msg-created_at `date -Is` --signing-key key --signing-cert cert --content set_js_app.json | curl ${CCF_URL}/gov/proposals -k -H "content-type: application/cose" --data-binary @-)
echo "Response from CCF: $content"
proposal=$(echo "${content}" | jq '.proposal_id')
echo "The proposal_id: $proposal"
echo "proposal=$proposal" >> $GITHUB_OUTPUT