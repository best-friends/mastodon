import { connect } from 'react-redux';
import Announcements from '../components/announcements';
import { toggleAnnouncements } from '../../../actions/announcements';
import { createSelector } from 'reselect';
import { Map as ImmutableMap } from 'immutable';

const customEmojiMap = createSelector([state => state.get('custom_emojis')], items => items.reduce((map, emoji) => map.set(emoji.get('shortcode'), emoji), ImmutableMap()));

const mapStateToProps = (state) => ({
  announcements: state.getIn(['announcements', 'items']),
  emojiMap: customEmojiMap(state),
  visible: state.getIn(['announcements', 'visible']),
});

const mapDispatchToProps = (dispatch) => ({
  onToggle () {
    dispatch(toggleAnnouncements());
  },
});

export default connect(mapStateToProps, mapDispatchToProps)(Announcements);
