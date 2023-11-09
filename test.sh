set -xe

curl --request POST \
     --url https://api.truelayer-sandbox.com/v3/payments \
     --header 'Idempotency-Key: 44C9CBCE-7F06-11EE-8CCF-FA38A042B5E7' \
     --header 'Tl-Signature: eyJ0bF92ZXJzaW9uIjoiMiIsInRsX2hlYWRlcnMiOiJJZGVtcG90ZW5jeS1LZXkiLCJraWQiOiI3NWMyNWIyMC0zOWM5LTRmNjgtYWQyNC1hMzA2NTAyN2NiMzUiLCJhbGciOiJFUzUxMiJ9..ATQ_H0MG-4Xs8WVWolB20YHEybPjn52wQK9UPP8JwvRFd3QCXm74sbaqwZAl8NclbqrPE0VSk0q4aJ9Ja14RAGVOAPsCHKsDU6hpKGe3puonYbORImDJDIs-a6pHcF7pbabNQXm582CQCQtcf2HU9YYZ2_szNZ-slHlmaVjGrW53On69' \
     --header 'accept: application/json; charset=UTF-8' \
     --header 'Authorization: Bearer eyJhbGciOiJSUzI1NiIsImtpZCI6IjE0NTk4OUIwNTdDOUMzMzg0MDc4MDBBOEJBNkNCOUZFQjMzRTk1MTBSUzI1NiIsIng1dCI6IkZGbUpzRmZKd3poQWVBQ291bXk1X3JNLWxSQSIsInR5cCI6ImF0K2p3dCJ9.eyJpc3MiOiJodHRwczovL2F1dGgudHJ1ZWxheWVyLXNhbmRib3guY29tIiwibmJmIjoxNjk5NTM3NTM5LCJpYXQiOjE2OTk1Mzc1MzksImV4cCI6MTY5OTU0MTEzOSwiYXVkIjoicGF5bWVudHNfYXBpIiwic2NvcGUiOlsicGF5bWVudHMiXSwiY2xpZW50X2lkIjoic2FuZGJveC1idGR0LTQ4YmYxZSIsImp0aSI6IjBDMDc5MEMzMjJFN0I3MUU3NkMxMzREMkU0MTU5RDk4In0.xqOSTPek-FCBxOy19iLDoOBtmT_3rxfC3x3ke3IYdqQ__4lwqEeWYqIBGmOlJ2BLW_esyfisYvjFBegVBxbnTSBrntt9jhMtdjN1KETchJ0zznL3KbQCOQ-HM8O5oGJiy6cx8nZgjzLN0e4SJaiMF4Y4E3o3OnOTgRXDev3FPYUEwLEKnWWmkWEVIPM6VlhdeMZqxrBxGMb543GbHZFS3tBEqX2QM4aM6NlmysT3GSItcM1UTQtkC5eMe0_cUv7K44xbSBLv1q2THnPR4oRPRHiXRm0nxxOQjVavtIDNpw2AEm7Qh5klLu9JJ6ls_h6EOW_RHVwu5FwoMS2N__HI1g'\
     --header 'content-type: application/json; charset=UTF-8' \
     --data '
{
  "currency": "GBP",
  "payment_method": {
    "type": "bank_transfer",
    "provider_selection": {
      "type": "user_selected",
      "filter": {
        "countries": [
          "DE"
        ],
        "release_channel": "general_availability",
        "customer_segments": [
          "retail"
        ]
      },
      "scheme_selection": {
        "type": "instant_only",
        "allow_remitter_fee": false
      }
    },
    "beneficiary": {
      "type": "merchant_account",
      "verification": {
        "type": "automated"
      },
      "merchant_account_id": "AB8FA060-3F1B-4AE8-9692-4AA3131020D0",
      "account_holder_name": "Ben Eficiary",
      "reference": "payment-ref"
    }
  },
  "user": {
    "id": "f9b48c9d-176b-46dd-b2da-fe1a2b77350c",
    "name": "Remi Terr",
    "email": "remi.terr@aol.com",
    "phone": "+447777777777",
    "date_of_birth": "1990-01-31"
  },
  "amount_in_minor": 1
}
'
