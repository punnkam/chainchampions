import os
import json

path = '/Users/punnkam/Desktop/projects/chainchampions/hardhat/metadata'
ipfs = 'ipfs://QmXokxxhiPhMkhterfNdycGKYPHydmSJS4WQvp6NuAyesF'

files = os.listdir(f'{path}/meta2')

# for file in files:
#     with open(f'{path}/meta/{file}', "r+") as f:
#         data = json.load(f)
#         num = file.split('.')[0]
#         data['image'] = f'{ipfs}/{num}.png'
#         # print(data['image'])
#         f.seek(0)
#         json.dump(data, f)
#         f.truncate()


for file in files:
    name = file.split('.')[0]
    os.rename(f'{path}/meta2/{file}', f'{path}/meta3/{name}')


# print(files)