#!/bin/bash

# 2. Foundry ve Hardhat Kurulumu
echo "Foundry'yi yüklüyoruz..."
curl -L https://foundry.paradigm.xyz | bash

# PATH ayarlarını güncelle
echo 'export PATH="$HOME/.foundry/bin:$PATH"' >> ~/.bashrc
# veya zsh kullanıyorsanız
# echo 'export PATH="$HOME/.foundry/bin:$PATH"' >> ~/.zshrc

# .bashrc veya .zshrc dosyasını yeniden yükle
source ~/.bashrc
# veya zsh kullanıyorsanız
# source ~/.zshrc

# Foundry'nin kurulduğunu kontrol et
if ! command -v forge &> /dev/null
then
    echo "forge komutu bulunamadı. Lütfen Foundry'nin yüklenip yüklenmediğini kontrol edin."
    echo "Lütfen 'foundryup' komutunu çalıştırarak Foundry'yi yükleyin."
    exit 1
fi

echo "Foundry güncellendi ve PATH'e eklendi."

# Foundry'nin yüklendiğini doğrula
echo "Foundry versiyonunu kontrol ediyoruz..."
forge --version

echo "Hardhat'i yüklüyoruz..."
npm install --save-dev hardhat

# 3. Bağımlılıkları Yükle
echo "Gerekli bağımlılıkları yüklüyoruz..."
yarn install

echo "Foundry paketlerini yüklüyoruz..."
forge install

# 4. Çevresel Değişkenleri Ayarla
# STORY_TESTNET_URL'i otomatik olarak ayarla
echo "STORY_TESTNET_URL=https://rpc.partner.testnet.storyprotocol.net/" > .env

echo "Lütfen STORY_PRIVATEKEY'i girin:"
read -s PRIVATEKEY

# .env dosyasını oluştur veya güncelle
echo "STORY_PRIVATEKEY=$PRIVATEKEY" >> .env

# 5. Sözleşmeleri Derle
echo "Sözleşmeleri derliyoruz..."
forge build

# 6. Deploy Scriptini Çalıştır
echo "Deploy işlemini başlatıyoruz..."
forge script script/deploy.s.sol:DeployScript --rpc-url $STORY_TESTNET_URL --private-key $PRIVATEKEY --broadcast

echo "Deploy işlemi tamamlandı. Kontrol edebilirsiniz."

# 7. Ekstra Bilgi
echo "Deployment sonucu kontrol edin ve sözleşme adresini blockchain explorer üzerinden doğrulayın."
