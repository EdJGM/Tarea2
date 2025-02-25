package banco.banco;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import org.springframework.http.ResponseEntity;

import java.util.*;

@RestController
@RequestMapping("/cards")
public class CardController {

    private final CardRepository cardRepository;

    @Autowired
    public CardController(CardRepository cardRepository) {
        this.cardRepository = cardRepository;
    }

    @PostMapping("/add")
    public ResponseEntity<?> addCard(@RequestBody Card card) {
        System.out.println("📌 JSON recibido en el backend: " + card);

        if (card.getUserId() == null || card.getCardNumber() == null) {
            return ResponseEntity.badRequest().body("Faltan datos obligatorios.");
        }

        if (cardRepository.findByUserId(card.getUserId()).stream()
                .anyMatch(c -> c.getCardNumber().equals(card.getCardNumber()))) {
            return ResponseEntity.status(HttpStatus.CONFLICT).body("Esta tarjeta ya está registrada.");
        }

        card.setIsFrozen(false);
        Card savedCard = cardRepository.save(card);
        return ResponseEntity.ok(savedCard);
    }



    @GetMapping("/user/{userId}")
    public ResponseEntity<Map<String, Object>> getCardsByUser(@PathVariable Long userId) {
        List<Card> cards = cardRepository.findByUserId(userId);

        Map<String, Object> response = new HashMap<>();
        response.put("cards", cards != null ? cards : new ArrayList<>()); // ✅ Asegura que sea un objeto con "cards"

        System.out.println("Respuesta del backend en getCardsByUser: " + response); // 🔥 Debug
        return ResponseEntity.ok(response);
    }

    @GetMapping("/{id}")
    public ResponseEntity<Card> getCardById(@PathVariable Long id) {
        return cardRepository.findById(id)
                .map(card -> ResponseEntity.ok().body(card))
                .orElseGet(() -> ResponseEntity.notFound().build());
    }


    @PutMapping("/freeze/{id}")
    public ResponseEntity<?> freezeCard(@PathVariable Long id) {
        return cardRepository.findById(id)
                .map(card -> {
                    card.setIsFrozen(!card.getIsFrozen());
                    cardRepository.save(card);
                    return ResponseEntity.ok(card);
                }).orElse(ResponseEntity.status(HttpStatus.BAD_REQUEST).build());
    }

    @DeleteMapping("/delete/{id}")
    public ResponseEntity<?> deleteCard(@PathVariable Long id) {
        if (cardRepository.existsById(id)) {
            cardRepository.deleteById(id);
            return ResponseEntity.ok("Tarjeta eliminada correctamente.");
        } else {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("Tarjeta no encontrada");
        }
    }

    @GetMapping("/exists")
    public ResponseEntity<Map<String, Object>> cardExists(@RequestParam String card){
        Optional<Card> cardOpt = cardRepository.findByCardNumber(card);
        Map<String, Object> response = new HashMap<>();
        response.put("exists", cardOpt.isPresent());
        return ResponseEntity.ok(response);
    }
}
