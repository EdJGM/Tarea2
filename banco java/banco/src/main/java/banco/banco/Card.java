package banco.banco;

import com.fasterxml.jackson.annotation.JsonProperty;
import jakarta.persistence.*;
import lombok.Data;

@Entity
@Data
@Table(name = "cards")
public class Card {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @JsonProperty("userId") // Asegura que el JSON reconozca el campo
    @Column(nullable = false)
    private Long userId;

    @JsonProperty("cardNumber") // Asegura que el JSON reconozca "number" en vez de "cardNumber"
    @Column(nullable = false, unique = true)
    private String cardNumber;

    @JsonProperty("isFrozen") // Permite el mapeo correcto del JSON
    private Boolean isFrozen = false;

    public Long getUserId() {
        return userId;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
    }

    public String getCardNumber() {
        return cardNumber;
    }

    public void setCardNumber(String cardNumber) {
        this.cardNumber = cardNumber;
    }

    public Boolean getFrozen() {
        return isFrozen;
    }

    public void setFrozen(Boolean frozen) {
        isFrozen = frozen;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }
}
