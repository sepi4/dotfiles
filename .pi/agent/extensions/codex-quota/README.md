# Paikallinen Codex-kiintiönäyttö

Pi löytää tämän kansion `index.ts`-tiedoston automaattisesti, kun kansio
on käytössä sijainnissa `~/.pi/agent/extensions/codex-quota/`.
Testitiedostoa ja README:tä ei ladata laajennuksina.

Voit kokeilla dotfiles-kansion juuresta ilman automaattisesti ladattavia
laajennuksia:

```bash
pi -ne -e ./.pi/agent/extensions/codex-quota/index.ts
```

Kirjaudu Pi:ssä `/login openai-codex` ja valitse sen malli komennolla
`/model`. Tavallinen OpenAI API-avain ja natiivi `openai`-kirjautuminen
eivät ole tämän pienen laajennuksen tukemia käyttötietolähteitä.

Näyttö: `codex: 5h 30% | viikko 18% käytetty`.
Prosentit tarkoittavat kulutettua kiintiötä, eivät kellotettua työaikaa.
Puuttuva ikkuna näkyy viivana, ei nollana. Lisäkiintiöt ja mallikohtaiset
kiintiöt (esimerkiksi Spark) eivät kuulu tähän versioon.

Päivitys tapahtuu käynnistyksessä, mallin vaihtuessa ja viiden minuutin välein.
Komento `/codex-quota` päivittää tiedot käsin. Muilla palveluntarjoajilla
näyttö piilotetaan. Verkko- tai kirjautumisvirhe korvaa prosentit virhetekstillä.

Jos dotfiles-järjestelysi ei jo linkitä tai kopioi tätä kansiota käyttöön,
voit kopioida sen dotfiles-kansion juuresta:

```bash
mkdir -p ~/.pi/agent/extensions/codex-quota
cp ./.pi/agent/extensions/codex-quota/index.ts ~/.pi/agent/extensions/codex-quota/index.ts
```

Poista mahdollinen aiempi `~/.pi/agent/extensions/codex-quota.ts`-kopio,
jotta laajennus ei lataudu kahdesti. Käynnistä Pi uudelleen tai suorita
`/reload`. Älä lataa samaa laajennusta lisäksi `-e`-valitsimella.
Poista käytöstä poistamalla käyttöön otettu kopio tai linkki ja suorittamalla
`/reload`.

## Tietoturva ja rajoitukset

- Ei ulkopuolisia riippuvuuksia, tiedostojen lukemista, aliohjelmia tai lokitusta.
- Pyytää OAuth-tunnisteen Pi:n omasta mallirekisteristä. Pi voi uusia ja
  tallentaa kirjautumisen normaalin kirjautumismekanisminsa kautta.
- Tarkistaa mallin ja ratkaistun kirjautumisen palveluosoitteen ennen käyttöä.
- Lähettää tunnisteen ja tilitunnisteen vain GET-pyyntöön osoitteeseen
  `https://chatgpt.com/backend-api/wham/usage`. Ei seuraa uudelleenohjauksia.
- Ei muuta mallipyyntöjä, Fast-asetuksia tai käyttökiintiöitä.
- Aikakatkaisu 10 sekuntia; sulkeminen ja mallinvaihto keskeyttävät verkkopyynnön.
- Rajapinta on dokumentoimaton ja voi muuttua. Tämä ei ole OpenAI:n virallinen
  laajennus eikä täydellisen turvallisuuden takuu.
- Tehty paikallisen Pi 1.0.4:n rajapinnoille. Testattu simuloiduilla vastauksilla,
  ei käyttäjän oikeilla kirjautumistiedoilla tai palvelun oikealla vastauksella.

Testit ilman verkkoa tai kirjautumistunnisteita:

```bash
node --experimental-strip-types --test .pi/agent/extensions/codex-quota/codex-quota.test.ts
```
