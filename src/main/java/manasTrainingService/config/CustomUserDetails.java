package manasTrainingService.config;

import lombok.Getter;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import manasTrainingService.entity.User;

import java.util.Collection;

@Getter
public class CustomUserDetails implements UserDetails {

    private final User user;
    private final Collection<? extends GrantedAuthority> authorities;

    public CustomUserDetails(User user, Collection<? extends GrantedAuthority> authorities) {
        this.user = user;
        this.authorities = authorities;
    }

    public String getName() {
        return user.getName();
    }

    public String getLastName() {
        return user.getLastName();
    }

    public String getFullName() {
        String lastName = user.getLastName();
        if (lastName != null && !lastName.isBlank() && !"null".equalsIgnoreCase(lastName)) {
            return user.getName() + " " + lastName;
        }
        return user.getName();
    }

    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        return authorities;
    }

    @Override
    public String getPassword() {
        return user.getPasswordHash();
    }

    @Override
    public String getUsername() {
        return user.getEmail();
    }

    @Override
    public boolean isAccountNonExpired() {
        return true;
    }

    @Override
    public boolean isAccountNonLocked() {
        return true;
    }

    @Override
    public boolean isCredentialsNonExpired() {
        return true;
    }

    @Override
    public boolean isEnabled() {
        return user.getIsActive();
    }

    public boolean hasRole(String role) {
        return authorities.stream()
                .anyMatch(auth -> auth.getAuthority().equals(role));
    }

}
